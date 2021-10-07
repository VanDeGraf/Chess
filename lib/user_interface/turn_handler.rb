class TurnHandler
  attr_reader :has_error

  def initialize
    @has_error = false
  end

  # @return [Symbol, nil]
  def perform_action; end

  # @return [String]
  def error_msg; end
end
