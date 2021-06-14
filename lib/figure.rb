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
end
