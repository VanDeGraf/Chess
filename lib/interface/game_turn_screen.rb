class GameTurnScreen < Screen
  def initialize(game)
    super('Chess Game Turn', input: init_input_params)
    @game = game
    @default_moves = []
    @special_moves = []
    init_moves
  end

  def init_moves
    @game.board.possible_moves(@game.current_player.color).each do |move|
      if move.special?
        @special_moves << move
      else
        @default_moves << move
      end
    end
  end

  def init_input_params
    ScreenDataInput.new(self,
                        'Enter your move or command',
                        filters: [
                          init_filter_simple_move,
                          init_filter_command,
                          init_filter_special_move,
                          init_filter_notation_move
                        ],
                        default_errmsg: "Can't parse inputted string, enter /help for more info about input.")
  end

  def init_filter_simple_move
    InputFilter.new(/^(([a-h][1-8]) ([a-h][1-8]))$/, handler: proc { |match_data|
      {
        action: :move,
        point_start: Coordinate.from_s(match_data[2]),
        point_end: Coordinate.from_s(match_data[3])
      }
    })
  end

  def init_filter_command
    InputFilter.new(%r{^(/([a-z]+) ?(\S* ?)*)$}, handler: proc { |match_data|
      {
        action: :command,
        command: match_data[2],
        arguments: match_data[3].split
      }
    })
  end

  def init_filter_special_move
    InputFilter.new(/^(s (\d+))$/, handler: proc { |match_data|
      {
        action: :special_move,
        move_index: match_data[2].to_i - 1
      }
    })
  end

  def init_filter_notation_move
    InputFilter.new(/^([BNQKR]?[a-h]?[1-8]?x?[a-h][1-8]=?[BNQKR]?)|(O-O)|(O-O-O)$/,
                    handler: proc { |match_data|
                      {
                        action: :notation_move,
                        string: match_data[0]
                      }
                    })
  end

  def self.show_and_read(game)
    instance = new(game)
    instance.draw
    instance.handle_input
  end

  def draw
    Interface.clear_console
    print "\t#{@header}\n"
    Interface.draw_board(@game.board)
    unless @special_moves.empty?
      puts 'You can do one of this special moves: '
      @special_moves.each_with_index { |move, i| puts "#{i + 1}) #{move}" }
    end
    puts "Player #{@game.current_player} turn."
    puts @input.draw
  end

  # @return [Symbol, Movement]
  def handle_input
    result = nil
    while result.nil?
      action = @input.handle_console_input
      result = perform_action(action)
      draw
    end
    result
  end

  def perform_action(action)
    case action[:action]
    when :command
      handle_input_command(action)
    when :special_move
      handle_input_special_move(action)
    when :move
      handle_input_move(action)
    when :notation_move
      handle_input_notation_move(action)
    end
  end

  private

  # @return [Symbol, nil]
  def handle_input_command(action)
    case action[:command]
    when 'save'
      handle_input_command_save
    when 'export'
      handle_input_command_export
    when 'mm', 'menu'
      :main_menu
    when 'draw'
      handle_input_command_draw
    when 'surrender', 'sur'
      handle_input_command_surrender
    when 'history'
      TurnHistoryScreen.show(@game)
    when 'help'
      CommandHelpScreen.show
    when 'quit', 'exit'
      :quit
    else
      @input.error_message = "Not found command with name: #{action[:command]}"
      nil
    end
  end

  def handle_input_command_draw
    if @game.opposite_player.is_a?(Computer)
      MessageScreen.show("Computer player can't accept your draw request!")
    elsif AcceptRequestScreen.show_and_read(
      "#{@game.current_player}, are you sure you want to offer a draw to your opponent?"
    ) && AcceptRequestScreen.show_and_read(
      "#{@game.current_player} wants to end the game in a draw, #{@game.opposite_player} do you agree?"
    )
      :draw
    end
  end

  def handle_input_command_surrender
    if @game.opposite_player.is_a?(Computer)
      MessageScreen.show("Computer player can't accept your surrender request!")
    elsif AcceptRequestScreen.show_and_read(
      "#{@game.current_player}, are you sure you want surrender?"
    ) && AcceptRequestScreen.show_and_read(
      "#{@game.current_player} wants surrender, #{@game.opposite_player} do you agree?"
    )
      :surrender
    end
  end

  def handle_input_command_save
    SaveLoadScreen.show_and_read(:save, game: @game)
    nil
  end

  def handle_input_command_export
    SaveLoadScreen.show_and_read(:export, game: @game)
    nil
  end

  # @return [Movement, nil]
  def handle_input_move(action)
    @default_moves.any? do |move|
      return move if move.point_start == action[:point_start] &&
                     move.point_end == action[:point_end]
    end
    @input.error_message = "Sorry, you can't move here (or from)."
    nil
  end

  # @return [Movement, nil]
  def handle_input_special_move(action)
    if !@special_moves.empty? && action[:move_index].between?(0, @special_moves.length - 1)
      return @special_moves[action[:move_index]]
    end

    @input.error_message = 'Mismatch number of special move choice.'
    nil
  end

  # @return [Movement, nil]
  def handle_input_notation_move(action)
    move = MovementGenerator.algebraic_notation(@default_moves + @special_moves)[action[:string]]
    if move.nil?
      @input.error_message = "Sorry, you can't move here (or from)."
      nil
    else
      move
    end
  end
end
