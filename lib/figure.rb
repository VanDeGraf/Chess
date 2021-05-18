class Figure
  $figure = [
    rook: ♜,
    knight: ♞,
    bishop: ♝,
    queen: ♛,
    king: ♚,
    pawn: ♟,
  ]

  $color = [
    white: 37,
    black: 30,
  ]

  attr_reader :figure, :color, :coordinate

  def initialize(figure_name, color_name)
    @figure = figure_name
    @color = color_name
  end

  def to_s
    "\e[#{$color[color]}m#{$figure[figure]}\e[0m"
  end
end
