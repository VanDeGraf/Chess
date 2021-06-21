class PlayerNameRequestScreen < Screen
  # @param color [Symbol]
  def initialize(color)
    super('Name Request', input: ScreenDataInput.new(
      "Player with #{color} figures, enter your name", filter: /^[a-zA-Z .']+$/
    ))
  end

  # @param color [Symbol]
  # @return [Player]
  def self.show_and_read(color)
    instance = new(color)
    instance.draw
    Player.new(instance.handle_input, color)
  end

  # @return [String]
  def handle_input
    @input.handle_console_input do |input|
      if input.nil?
        draw
      else
        input
      end
    end
  end
end
