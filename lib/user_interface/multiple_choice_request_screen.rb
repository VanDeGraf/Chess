class MultipleChoiceRequestScreen < Screen
  # @param choices [Array<String>]
  # @param request_message [String]
  def initialize(choices, request_message: nil)
    super('Multiple-choice request', input: ScreenMenuInput.new(
      self,
      choices.map.with_index { |choice, i| MenuAction.new(i, choice) }
    ))
    @request_message = request_message
  end

  def draw
    UserInterface.clear_console
    UserInterface.io.write "\t#{@header}\n"
    UserInterface.io.writeline @request_message unless @request_message.nil?
    UserInterface.io.writeline @input.draw
  end

  def handle_input
    @input.handle_console_input
  end

  # @param choices [Array<String>]
  # @param request_message [String]
  # @return [Integer]
  def self.show_and_read(choices, request_message)
    instance = new(choices, request_message: request_message)
    instance.draw
    instance.handle_input
  end
end
