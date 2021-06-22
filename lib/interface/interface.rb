module Interface

  def self.clear_console
    system('clear') || system('cls')
  end

  # @param board [Board]
  # @return [Void]
  def self.draw_board(board)
    rotated_to_player = if board.history.last.nil?
                          :white
                        else
                          board.history.last.figure.color == :white ? :black : :white
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

  FIGURE_AS_UNICODE = {
    rook: '♜',
    knight: '♞',
    bishop: '♝',
    queen: '♛',
    king: '♚',
    pawn: '♟'
  }.freeze

  # @param coordinate [Coordinate]
  # @param figure [Figure,nil]
  # @return [Void]
  def self.draw_figure_at(coordinate, figure)
    if figure.nil?
      figure_string = '  '
    else
      color_num = figure.color == :white ? 37 : 30
      figure_string = " \e[#{color_num}m#{FIGURE_AS_UNICODE[figure.figure]}\e[0m"
    end
    print((coordinate.x + coordinate.y).odd? ? "\e[46m#{figure_string}\e[0m" : "\e[44m#{figure_string}\e[0m")
  end

  # @param figure [Figure]
  # @return [Void]
  def self.draw_figure(figure)
    color_num = figure.color == :white ? 37 : 30
    print " \e[#{color_num}m#{FIGURE_AS_UNICODE[figure.figure]}\e[0m"
  end
end