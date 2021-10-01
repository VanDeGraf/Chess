class ScreenInput
  attr_writer :error_message

  # @param screen [Screen]
  # @param description_message [String]
  def initialize(screen, description_message)
    @description_message = description_message
    @error_message = nil
    @screen = screen
  end

  # @return [String]
  def draw
    buffer = StringIO.new
    buffer << "Input error: #{@error_message}\n" unless @error_message.nil?
    buffer << "#{@description_message}\n"
    buffer.string
  end

  def handle_console_input
    until (handled = gets.chomp)
      @screen.draw
    end
    handled
  end
end
