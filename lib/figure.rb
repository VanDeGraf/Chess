# chess figure, not depends of board
class Figure
  attr_reader :figure, :color

  # @param type [Symbol] figure type
  # @param color [Symbol] figure color
  def initialize(type, color)
    # @type [Symbol]
    @figure = type
    # @type [Symbol]
    @color = color
  end

  def ==(other)
    return false if self.class != other.class

    @figure == other.figure && @color == other.color
  end

  def to_s
    @figure.to_s
  end
end
