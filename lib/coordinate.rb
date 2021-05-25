# board cell coordinate
class Coordinate
  attr_reader :x, :y

  # @param x [Fixnum]
  # @param y [Fixnum]
  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end

  # Represents table coordinate to chess coordinate string
  # @example 0,0 >> "a1"
  # @return [String]
  def to_s
    (97 + @x).chr + (@y + 1).to_s
  end

  # Create new coordinate with summarize inputted coordinates with current
  # @param x_add [Fixnum]
  # @param y_add [Fixnum]
  # @return [Coordinate]
  def relative(x_add, y_add)
    Coordinate.new(@x + x_add, @y + y_add)
  end

  # Represents chess string coordinate to table coordinate object
  # @param coordinate [String]
  # @example "a1" >> 0,0
  # @return [Coordinate]
  def self.from_s(coordinate)
    Coordinate.new(coordinate[0].ord - 97, coordinate[1].to_i - 1)
  end
end
