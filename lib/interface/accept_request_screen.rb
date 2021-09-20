class AcceptRequestScreen < Screen
  def initialize(request_message)
    super('Request', input: ScreenDataInput.new(
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
    @input.handle_console_input(-> { draw }) == 'y'
  end

  def draw
    Interface.clear_console
    print "\t#{@header}\n"
    puts @request_message
    puts @input.draw
  end
end
