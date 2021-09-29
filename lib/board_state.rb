class BoardState
  # @param board [Board]
  def initialize(board)
    # @type [Board]
    @board = board
    # @type [Hash<String, Boolean>]
    @calculated_states = {}
  end

  # clear current turn states
  def clear!
    @calculated_states = {}
  end

  def clone(board_clone)
    new_state = BoardState.new(board_clone)
    new_state.instance_variable_set(:@calculated_states, @calculated_states.clone)
    new_state
  end

  # @param color [Symbol]
  # @return [Boolean]
  def en_passant?(color)
    state_name = "en_passant_#{color}"
    unless @calculated_states.key?(state_name)
      @calculated_states[state_name] = @board.where_is(:pawn, color).any? do |coordinate|
        MovementGenerator.generate_from(coordinate, @board).any? { |move| move.is_a?(EnPassant) }
      end
    end
    @calculated_states[state_name]
  end

  # check inputted color is in shah(check) state, i.e. any enemy figure has possible move at next turn to beat king with
  # inputted color
  # @param color [Symbol]
  def shah?(color)
    state_name = "shah_#{color}"
    unless @calculated_states.key?(state_name)
      opposite_color = color == :white ? :black : :white
      @calculated_states[state_name] = @board.where_is(nil, opposite_color).any? do |coordinate|
        MovementGenerator.generate_from(coordinate, @board, check_shah: false)
                         .any? { |move| move.is_a?(Capture) && move.captured.figure == :king }
      end
    end
    @calculated_states[state_name]
  end

  # check inputted color is in mate(checkmate) state, i.e. after all possible moves inputted color is in shah state, or
  # now is in shah state and no possible moves
  # @param color [Symbol]
  def mate?(color)
    state_name = "mate_#{color}"
    unless @calculated_states.key?(state_name)
      moves = []
      @board.where_is(nil, color).each do |coordinate|
        moves += MovementGenerator.generate_from(coordinate, @board)
      end
      shah?(color) if moves.empty?
      @calculated_states[state_name] = moves.all? { |move_action| @board.move(move_action).state.shah?(color) }
    end
    @calculated_states[state_name]
  end

  # @param color [Symbol]
  def draw?(color)
    state_name = "draw_#{color}"
    unless @calculated_states.key?(state_name)
      @calculated_states[state_name] = stalemate?(color) || deadmate? || n_move?(75) ||
                                       @board.repetition_log.n_fold_repetition?(5)
    end
    @calculated_states[state_name]
  end

  # check inputted color is in stalemate state, i.e. now isn't in shah state and no possible moves
  # @param color [Symbol]
  def stalemate?(color)
    if @board.where_is(nil, color).any? do |coordinate|
      !MovementGenerator.generate_from(coordinate, @board).empty?
    end || !MovementGenerator.castling(@board, color).empty?
      false
    else
      !shah?(color)
    end
  end

  DEADMATE_PRESETS = [
    [
      { king: 1 },
      { king: 1 }
    ],
    [
      { king: 1 },
      { king: 1, bishop: 1 }
    ],
    [
      { king: 1 },
      { king: 1, knight: 1 }
    ],
    [
      { king: 1, bishop: 1 },
      { king: 1, bishop: 1 }
    ]
  ].freeze

  def deadmate?
    if figures_on_board(DEADMATE_PRESETS[0]) ||
       figures_on_board(DEADMATE_PRESETS[1]) ||
       figures_on_board(DEADMATE_PRESETS[2])
      true
    elsif figures_on_board(DEADMATE_PRESETS[3])
      deadmate_special3?
    else
      false
    end
  end

  def deadmate_special3?
    bishops_coordinate = @board.where_is(:bishop, nil)
    bc1sum = bishops_coordinate[0].x + bishops_coordinate[0].y
    bc2sum = bishops_coordinate[1].x + bishops_coordinate[1].y
    (bc1sum.even? && bc2sum.even?) || (bc1sum.odd? && bc2sum.odd?)
  end

  # generic check Fifty-move and Seventy-five-move draw rules
  # @param turns_count [Integer]
  def n_move?(turns_count)
    return false if @board.history.length < turns_count

    @board.history.last(turns_count).none? do |move|
      [Capture, PromotionCapture, PromotionMove].include?(move.class) ||
        (move.is_a?(Move) && move.figure.figure == :pawn)
    end
  end

  private

  def figures_on_board(figures)
    figures_by_color = all_figures_by_color
    (figures[0].eql?(figures_by_color[:white]) && figures[1].eql?(figures_by_color[:black])) ||
      (figures[1].eql?(figures_by_color[:white]) && figures[0].eql?(figures_by_color[:black]))
  end

  def all_figures_by_color
    figures_by_color = { white: {}, black: {} }
    @board.each_figure(skip_empty: true) do |figure|
      if figures_by_color[figure.color].key?(figure.figure)
        figures_by_color[figure.color][figure.figure] += 1
      else
        figures_by_color[figure.color][figure.figure] = 1
      end
    end
    figures_by_color
  end
end
