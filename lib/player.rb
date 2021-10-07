class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  # @param game [Game]
  # @return [Symbol, nil]
  def turn(game)
    GameTurnScreen.show_and_read(game)
  end

  def to_s
    "#{@name}(#{@color})"
  end
end
