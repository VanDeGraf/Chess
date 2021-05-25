# chess , not depends of board
class Figure
  # Unicode symbol assoc with chess figure types
  $figure = {
      rook: "♜",
      knight: "♞",
      bishop: "♝",
      queen: "♛",
      king: "♚",
      pawn: "♟",
  }
  # Console color for opposites figure groups
  $color = {
      white: 37,
      black: 30,
  }

  attr_reader :figure, :color, :coordinate

  # @param type [Symbol] figure type
  # @param color [Symbol] figure color
  def initialize(type, color)
    # @type [Symbol]
    @figure = type
    # @type [Symbol]
    @color = color
  end

  # Return Unicode symbol depends by figure type and color
  # @return [String]
  def to_s
    " \e[#{$color[@color]}m#{$figure[@figure]}\e[0m"
  end
end
