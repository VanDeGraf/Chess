class Movement
  attr_reader :figure

  # @param figure [Figure]
  def initialize(figure)
    @figure = figure
  end

  def special?; end

  # @param board [Board]
  # @return [Figure, nil] return captured figure, if it's happened
  def perform_movement(board) end

  # @param file [Boolean]
  # @param rank [Boolean]
  # @return [String]
  def algebraic_notation(file: false, rank: false) end

  def ==(other)
    return false if self.class != other.class

    instance_variables.all? do |var_name|
      instance_variable_get(var_name) == other.instance_variable_get(var_name)
    end
  end
end
