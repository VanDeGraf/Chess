class Movement
  attr_reader :figure

  # @param figure [Figure]
  def initialize(figure)
    @figure = figure
  end

  def special?
    false
  end
end
