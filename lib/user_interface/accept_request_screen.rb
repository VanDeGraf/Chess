class AcceptRequestScreen < Screen
  def initialize(request_message)
    super('Request', input: ScreenDataInput.new(
      self,
      'Enter y to accept and n to decline request',
      filters: [
        InputFilter.new(/^y|n$/)
      ]
    ))
    @request_message = request_message
  end

  # @param request_message [String]
  # @return [Boolean]
  def self.show_and_read(request_message)
    instance = new(request_message)
    instance.draw
    instance.handle_input
  end

  # @return [Boolean]
  def handle_input
    @input.handle_console_input == 'y'
  end

  def draw
    UserInterface.io.clear
    UserInterface.io.write "\t#{@header}\n"
    UserInterface.io.writeline @request_message
    UserInterface.io.writeline @input.draw
  end
end
