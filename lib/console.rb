module Console
  def self.param_input(options)
    input = gets.chomp
    until input.match?(options[:input][:filter])
      options[:input][:error_message] = "You must follow this regex mask: #{options[:input][:filter]}"
      update(options)
      input = gets.chomp
    end
    input
  end

  # @return [Symbol]
  def self.menu_input(options)
    input = gets.chomp
    menu_items_count = options[:input][:actions].count { |menu_item| menu_item.keys[0] != :delimiter }
    until input.match?(/^\d+$/) && input.to_i.between?(1, menu_items_count)
      if !input.match?(/^\d+$/)
        options[:input][:error_message] = 'Only positive integer can be inputted!'
      elsif !input.to_i.between?(1, menu_items_count)
        options[:input][:error_message] = "Integer must be between 1 and #{menu_items_count}!"
      end
      update(options)
      input = gets.chomp
    end
    item_number = 1
    options[:input][:actions].each do |menu_item|
      next if menu_item.keys[0] == :delimiter
      return menu_item.keys[0] if item_number == input.to_i

      item_number += 1
    end
  end

  # @param default_moves [Array<Move>]
  # @param special_moves [Array<Move>]
  # @return [Move,Symbol, nil]
  def self.player_turn_input(default_moves, special_moves, options)
    input = options[:game].current_player.turn_input_parse

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
      if !special_moves.empty? && input[:move_index].between?(0, special_moves.length - 1)
        return special_moves[input[:move_index]]
      end

      options[:input][:error_message] = 'Mismatch number of special move choice.'
    when :command
      case input[:command]
      when 'save'
        return :save_game
      when 'export'
        return :export_to_PGN
      when 'mm'
        return :main_menu
      when 'draw'
        return :draw
      when 'surrender'
        return :surrender
      when 'history'
        return :show_history
      when 'help'
        return :cmd_help
      when 'rules'
        return :rules
      when 'quit'
        return :quit
      else
        options[:input][:error_message] = "Not found command with name: #{input[:command]}"
      end
    end
    nil
  end

  def self.popup_message(msg)
    update
    puts msg
    puts "\nPress Enter to continue...\n"
    gets
  end

  # @return [Void]
  def self.draw_game_turn(options)
    draw_board(options[:game].board)
    puts "Player #{options[:game].current_player} turn."
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
    draw_board(options[:game].board)
    if options[:game].winner.nil?
      puts "\nDraw! No winners!"
    else
      puts "\nPlayer #{options[:game].winner} Win! Congratulations!"
    end
    draw_input(options)
  end

  # @return [Void]
  def self.draw_input(options)
    if !options[:input][:actions].nil? && options[:input][:actions].is_a?(Array)
      menu_item_number = 1
      options[:input][:actions].each do |menu_item|
        if menu_item.keys[0] == :delimiter
          puts menu_item.values[0]
        else
          puts "#{menu_item_number})#{menu_item.values[0]}"
          menu_item_number += 1
        end
      end
    end
    puts "Input error: #{options[:input][:error_message]}" unless options[:input][:error_message].nil?
    puts options[:input][:description_message]
  end

  # @param options [Hash]
  # @return [Void]
  def self.update(options = nil)
    system('clear') || system('cls')
    return if options.nil?

    draw_main_menu(options) if options[:screen] == :main_menu
    draw_game_turn(options) if options[:screen] == :game_turn
    draw_end_game(options) if options[:screen] == :end_game
    draw_input(options) if options[:screen] == :player_welcome
    draw_input(options) if options[:screen] == :save_name_input
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
      figure_string = '  '
    else
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
    end
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
