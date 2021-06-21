class MenuAction
  attr_reader :name, :title

  # @param name [Symbol]
  # @param title [String]
  def initialize(name, title)
    @name = name
    @title = title
  end

  # @param index [Integer]
  # @return [String]
  def draw(index)
    "#{index + 1}) #{@title}\n"
  end
end
