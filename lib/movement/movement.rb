class Movement
  attr_reader :figure

  # @param figure [Figure]
  def initialize(figure)
    @figure = figure
  end

  def special?
    false
  end

  def ==(other)
    return false if self.class != other.class

    instance_variables.all? do |var_name|
      if other.instance_variables.include?(var_name)
        instance_variable_get(var_name) == other.instance_variable_get(var_name)
      else
        false
      end
    end
  end
end
