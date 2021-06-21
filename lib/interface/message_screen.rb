class MessageScreen < Screen
  # @param message [String]
  def initialize(message)
    super('Message')
    @message = message
  end

  def draw
    Interface.clear_console
    print "\t#{@header}\n"
    puts @message
    print "\nPress Enter to continue...\n"
  end

  # @param message [String]
  def self.show(message)
    instance = new(message)
    instance.draw
    gets
    nil
  end
end
