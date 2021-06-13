module View
  def self.main_menu
    options = {
      screen: :main_menu,
      header: 'Main Menu',
      input: {
        actions: [
          'Play game Human vs Human'
          # 'Play game Human vs Computer',
          # 'Play game Computer vs Computer',
          # 'Load saved game',
        ],
        description_message: 'Enter the number of the action you would like to perform: ',
        error_message: nil
      }
    }
    update(options)
    menu_input(options)
  end

  def self.game_turn(board, player)
    possible_moves = board.where_is(nil, player.color).map do |coordinate|
      MovesGenerator.generate_from(coordinate, board)
    end
    default_moves = []
    special_moves = MovesGenerator.castling(board, player.color)
    possible_moves.flatten.each do |move|
      if move.kind == :move || move.kind == :capture
        default_moves << move
      else
        special_moves << move
      end
    end
    options = {
      screen: :game_turn,
      player: player,
      board: board,
      input: {
        description_message: 'Type your figure coordinate and endpoint coordinate (delim: space) [a1 a1], ' \
                                'special move with s and number [s 1] or command [/help]',
        error_message: nil
      }
    }
    unless special_moves.empty?
      options[:special_moves] = {
        description_message: 'You can do one of this special moves: '
      }
      options[:special_moves][:moves] = special_moves.map do |move|
        case move.kind
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
      end
    end
    update(options)
    until (move = player_turn_input(default_moves, special_moves, options))
      update(options)
    end
    move
  end

  def self.end_game(board, winner)
    options = {
      screen: :end_game,
      board: board,
      winner: winner,
      input: {
        actions: [
          'Go to Main Menu'
          # 'Save this game',
          # 'Export this game',
          # 'Show turns history',
        ],
        description_message: 'Enter the number of the action you would like to perform: ',
        error_message: nil
      }
    }
    update(options)
    menu_input(options)
  end

  def self.player_welcome(color)
    options = {
      screen: :player_welcome,
      color: color,
      input: {
        description_message: "Player with #{color} figures, enter your name: ",
        error_message: nil
      }
    }
    update(options)
    while !(name = Player.name_input_parse).nil? && name[:action] == :error
      options[:input][:error_message] = name[:msg]
      update(options)
    end
    Player.new(name[:name], color)
  end

  def self.menu_input(options)
    input = gets.chomp
    until input.match?(/^\d+$/) && input.to_i.between?(1, options[:input][:actions].length)
      if !input.match?(/^\d+$/)
        options[:input][:error_message] = 'Only positive integer can be inputted!'
      elsif !input.to_i.between?(1, options[:input][:actions].length)
        options[:input][:error_message] = "Integer must be between 1 and #{options[:input][:actions].length}!"
      end
      update(options)
      input = gets.chomp
    end
    input.to_i
  end

  # @param default_moves [Array<Move>]
  # @param special_moves [Array<Move>]
  # @return [Move, nil]
  def self.player_turn_input(default_moves, special_moves, options)
    input = options[:player].turn_input_parse

    case input[:action]
    when :error
      options[:input][:error_message] = input[:msg]
      return nil
    when :move
      default_moves.any? do |move|
        return move if move.options[:point_start] == input[:point_start] &&
                       move.options[:point_end] == input[:point_end]
      end
      options[:input][:error_message] = "Sorry, you can't move here (or from)."
    when :special_move
      unless !special_moves.empty? && input[:move_index].between?(0, special_moves.length - 1)
        options[:input][:error_message] = 'Mismatch number of special move choice.'
      end
      return special_moves[input[:move_index]]
    end
    nil
  end

  # @return [Void]
  def self.draw_game_turn(options)
    draw_board(options[:board])
    puts "Player #{options[:player].name} (#{options[:player].color}) turn."
    unless options[:special_moves].nil?
      puts options[:special_moves][:description_message]
      options[:special_moves][:moves].each_with_index do |move_desc, i|
        puts "#{i + 1}) #{move_desc}"
      end
    end
    draw_input(options)
  end

  # @return [Void]
  def self.draw_main_menu(options)
    puts "\t#{options[:header]}"
    draw_input(options)
  end

  # @return [Void]
  def self.draw_end_game(options)
    puts "\tGame is over!"
    draw_board(options[:board])
    if options[:winner].nil?
      puts "\nDraw! No winners!"
    else
      puts "\nPlayer #{options[:winner].name} Win! Congratulations!"
    end
    draw_input(options)
  end

  # @return [Void]
  def self.draw_input(options)
    if !options[:input][:actions].nil? && options[:input][:actions].is_a?(Array)
      options[:input][:actions].each_with_index { |action, i| puts "#{i + 1})#{action}" }
    end
    puts "Input error: #{options[:input][:error_message]}" unless options[:input][:error_message].nil?
    puts options[:input][:description_message]
  end

  # @param options [Hash]
  # @return [Void]
  def self.update(options)
    system('clear') || system('cls')
    draw_main_menu(options) if options[:screen] == :main_menu
    draw_game_turn(options) if options[:screen] == :game_turn
    draw_end_game(options) if options[:screen] == :end_game
    draw_input(options) if options[:screen] == :player_welcome
  end

  # @param board [Board]
  # @return [Void]
  def self.draw_board(board)
    rotated_to_player = if board.history.last.nil?
                          :white
                        else
                          board.history.last.options[:figure].color == :white ? :black : :white
                        end
    point_start = 0
    point_end = 7
    step = 1
    if rotated_to_player == :white
      point_start, point_end = point_end, point_start
      step = -1
    end
    print '  '
    point_end.step(point_start, step * -1) { |x| print " #{(97 + x).chr}" }
    print "\n"
    point_start.step(point_end, step) do |y|
      print "#{y + 1} "
      point_end.step(point_start, step * -1) do |x|
        coordinate = Coordinate.new(x, y)
        draw_figure_at(coordinate, board.at(coordinate))
      end
      puts " #{y + 1}"
    end
    print '  '
    point_end.step(point_start, step * -1) { |x| print " #{(97 + x).chr}" }
    puts ' '
  end

  # @param coordinate [Coordinate]
  # @param figure [Figure,nil]
  # @return [Void]
  def self.draw_figure_at(coordinate, figure)
    if figure.nil?
      print '  '
      return
    end
    unicode = {
      rook: '♜',
      knight: '♞',
      bishop: '♝',
      queen: '♛',
      king: '♚',
      pawn: '♟'
    }
    color_num = figure.color == :white ? 37 : 30
    figure_string = " \e[#{color_num}m#{unicode[figure.figure]}\e[0m"
    print((coordinate.x + coordinate.y).odd? ? "\e[46m#{figure_string}\e[0m" : "\e[44m#{figure_string}\e[0m")
  end

  # @param figure [Figure]
  # @return [Void]
  def self.draw_figure(figure)
    unicode = {
      rook: '♜',
      knight: '♞',
      bishop: '♝',
      queen: '♛',
      king: '♚',
      pawn: '♟'
    }
    color_num = figure.color == :white ? 37 : 30
    print " \e[#{color_num}m#{unicode[figure.figure]}\e[0m"
  end
end
