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
    calculate_moves
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
        desc = case move.kind
               when :en_passant
                 "en passant from #{move.options[:point_start]} to #{move.options[:point_end]}"
               when :promotion_move
                 "pawn move to #{move.options[:point_end]} and promotion to #{move.options[:promoted_to].figure}"
               when :promotion_capture
                 "pawn capture enemy at #{move.options[:point_end]} and promotion to #{move.options[:promoted_to].figure}"
               when :castling_short
                 'castling short'
               when :castling_long
                 'castling long'
               end
        puts "#{i + 1}) #{desc}"
      end
    end
    puts "Player #{@game.current_player} turn."
    puts @input.draw
  end

  # @return [Symbol, Move]
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
      MessageScreen.show('Sorry, this feature not implemented yet!')
    when 'mm'
      :main_menu
    when 'draw'
      MessageScreen.show('Sorry, this feature not implemented yet!')
    when 'surrender'
      MessageScreen.show('Sorry, this feature not implemented yet!')
    when 'history'
      MessageScreen.show('Sorry, this feature not implemented yet!')
    when 'help'
      CommandHelpScreen.show
    when 'quit'
      :quit
    else
      @input.error_message = "Not found command with name: #{action[:command]}"
      nil
    end
  end

  # @return [Move, nil]
  def handle_input_move(action)
    @default_moves.any? do |move|
      return move if move.options[:point_start] == action[:point_start] &&
                     move.options[:point_end] == action[:point_end]
    end
    @input.error_message = "Sorry, you can't move here (or from)."
    nil
  end

  # @return [Move, nil]
  def handle_input_special_move(action)
    if !@special_moves.empty? && action[:move_index].between?(0, @special_moves.length - 1)
      return @special_moves[action[:move_index]]
    end

    @input.error_message = 'Mismatch number of special move choice.'
    nil
  end

  def calculate_moves
    possible_moves = @game.board.where_is(nil, @game.current_player.color).map do |coordinate|
      MovesGenerator.generate_from(coordinate, @game.board)
    end
    @default_moves = []
    @special_moves = MovesGenerator.castling(@game.board, @game.current_player.color)
    possible_moves.flatten.each do |move|
      if move.kind == :move || move.kind == :capture
        @default_moves << move
      else
        @special_moves << move
      end
    end
  end
end
