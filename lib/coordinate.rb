class Coordinate
  attr_reader :x, :y

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
  end

  def to_s
    (97 + @x).chr + (@y+1).to_s
  end
end
