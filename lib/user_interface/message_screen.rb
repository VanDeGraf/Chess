class MessageScreen < Screen
  # @param message [String]
  def initialize(message)
    super('Message')
    @message = message
  end

  def draw
    UserInterface.io.clear
    UserInterface.io.write "\t#{@header}\n"
    UserInterface.io.writeline @message
    UserInterface.io.write "\nPress Enter to continue...\n"
  end

  # @param message [String]
  def self.show(message)
    instance = new(message)
    instance.draw
    UserInterface.io.readline
    nil
  end
end
