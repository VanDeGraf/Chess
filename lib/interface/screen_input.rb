class ScreenInput
  attr_writer :error_message

  # @param description_message [String]
  def initialize(description_message)
    @description_message = description_message
    @error_message = nil
  end

  # @return [String]
  def draw
    buffer = StringIO.new
    buffer << "Input error: #{@error_message}\n" unless @error_message.nil?
    buffer << "#{@description_message}\n"
    buffer.string
  end

  # @yieldparam input [String, nil]
  def handle_console_input
    until (handled = yield(gets.chomp))
      yield(nil)
    end
    handled
  end
end
