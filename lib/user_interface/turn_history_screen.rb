class TurnHistoryScreen < Screen
  def initialize(game)
    super('Turn History')
    # @type [Game]
    @game = game
  end

  def draw
    UserInterface.io.clear
    UserInterface.io.write "\t#{@header}\n"
    @game.board.history.each do |move|
      player = move.figure.color == @game.current_player.color ? @game.current_player : @game.opposite_player
      UserInterface.io.writeline "#{player}: #{move}"
    end
    UserInterface.io.write "\nPress Enter to continue...\n"
  end

  # @param game [Game]
  def self.show(game)
    instance = new(game)
    instance.draw
    UserInterface.io.readline
    nil
  end
end
