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

  # @param screen_draw_method [Proc]
  def handle_console_input(screen_draw_method)
    until (handled = gets.chomp)
      screen_draw_method.call
    end
    handled
  end
end
