class PlayerNameRequestScreen < Screen
  # @param color [Symbol]
  def initialize(color)
    super('Name Request', input: ScreenDataInput.new(
      "Player with #{color} figures, enter your name",
      filters: [
        InputFilter.new(/^[a-zA-Z .']+$/)
      ]
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
    @input.handle_console_input(-> { draw })
  end
end
