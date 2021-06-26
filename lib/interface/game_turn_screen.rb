class GameTurnScreen < Screen
  def initialize(game)
    super('Chess Game Turn', input: ScreenDataInput.new(
      'Type your figure coordinate and endpoint coordinate [a1 a1], ' \
                                'special move with s and number [s 1] or command [/help]',
      filter: %r{^([a-h][1-8] [a-h][1-8])|(/[a-z]+ ?(\S* ?)*)|(s \d+)$}
    ))
    @game = game
    @default_moves = []
    @special_moves = []
    @game.board.possible_moves(@game.current_player.color).each do |move|
      if move.special?
        @special_moves << move
      else
        @default_moves << move
      end
    end
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
      @special_moves.each_with_index do |move, i|
        desc = case move
               when EnPassant
                 "en passant from #{move.point_start} to #{move.point_end}"
               when PromotionMove
                 "pawn move to #{move.point_end} and promotion to #{move.promoted_to.figure}"
               when PromotionCapture
                 "pawn capture enemy at #{move.point_end} and promotion to #{move.promoted_to.figure}"
               when Castling
                 if move.short
                   'castling short'
                 else
                   'castling long'
                 end
               end
        puts "#{i + 1}) #{desc}"
      end
    end
    puts "Player #{@game.current_player} turn."
    puts @input.draw
  end

  # @return [Symbol, Movement]
  def handle_input
    loop do
      action = @input.handle_console_input do |input|
        if input.nil?
          draw
          next
        end
        input_to_action(input)
      end
      case action[:action]
      when :command
        command = handle_input_command(action)
        return command unless command.nil?
      when :special_move
        move = handle_input_special_move(action)
        return move unless move.nil?
      when :move
        move = handle_input_move(action)
        return move unless move.nil?
      else
        next
      end
      draw
    end
    :stub
  end

  private

  def input_to_action(input)
    case input[0]
    when '/'
      input = input[1..input.length - 1].split
      {
        action: :command,
        command: input.shift,
        arguments: input
      }
    when 's'
      {
        action: :special_move,
        move_index: input.split[1].to_i - 1
      }
    else
      input = input.split
      {
        action: :move,
        point_start: Coordinate.from_s(input[0]),
        point_end: Coordinate.from_s(input[1])
      }
    end
  end

  # @return [Symbol, nil]
  def handle_input_command(action)
    case action[:command]
    when 'save'
      SaveLoadScreen.show_and_read(:save, game: @game)
      nil
    when 'export'
      SaveLoadScreen.show_and_read(:export, game: @game)
      nil
    when 'mm'
      :main_menu
    when 'draw'
      if @game.opposite_player.is_a?(Computer)
        MessageScreen.show("Computer player can't accept your draw request!")
      elsif AcceptRequestScreen.show_and_read(
        "#{@game.current_player}, are you sure you want to offer a draw to your opponent?"
      ) && AcceptRequestScreen.show_and_read(
        "#{@game.current_player} wants to end the game in a draw, #{@game.opposite_player} do you agree?"
      )
        :draw
      end
    when 'surrender'
      if @game.opposite_player.is_a?(Computer)
        MessageScreen.show("Computer player can't accept your surrender request!")
      elsif AcceptRequestScreen.show_and_read(
        "#{@game.current_player}, are you sure you want surrender?"
      ) && AcceptRequestScreen.show_and_read(
        "#{@game.current_player} wants surrender, #{@game.opposite_player} do you agree?"
      )
        :surrender
      end
    when 'history'
      TurnHistoryScreen.show(@game)
    when 'help'
      CommandHelpScreen.show
    when 'quit'
      :quit
    else
      @input.error_message = "Not found command with name: #{action[:command]}"
      nil
    end
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
end
