class CommandHelpScreen < MessageScreen
  def initialize
    super(
      "You can enter commands only when it is explicitly indicated.\n\n" \
        "\tCommand list:\n" \
        "/save - save current game state to specified file\n" \
        "/export - save current game state to specified file, use PGN format\n" \
        "/mm - go to main menu\n" \
        "/draw - offer the opponent a draw\n" \
        "/surrender - admit defeat, the opponent must accept it\n" \
        "/history - show game turns history\n" \
        "/help - show this screen\n" \
        "/quit - exit from this application\n\n" \
        "\tIn-Game turn input variants:\n" \
        "1)Simple, example: `a2 a4`,`b1 c3`\n" \
        "2)Algebraic Notation, example: `a4`,`Nc3`\n" \
        "3)Choose special move, if it exists, just with type number of move\n"
    )
    @header = 'Commands'
  end

  def self.show
    instance = new
    instance.draw
    gets
    nil
  end
end
