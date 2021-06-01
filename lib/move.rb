class Move
  attr_reader :kind, :options

  # @param kind [Symbol] type of figure moving
  # @param options [Hash] params of moving
  def initialize(kind, options = {})
    @kind = kind
    @options = options
  end
end