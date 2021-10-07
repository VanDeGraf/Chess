class TurnHistoryScreen < Screen
  def initialize(game)
    super('Turn History')
    # @type [Game]
    @game = game
  end

  def draw
    Interface.clear_console
    Interface.io.write "\t#{@header}\n"
    @game.board.history.each do |move|
      player = move.figure.color == @game.current_player.color ? @game.current_player : @game.opposite_player
      Interface.io.writeline "#{player}: #{move}"
    end
    Interface.io.write "\nPress Enter to continue...\n"
  end

  # @param game [Game]
  def self.show(game)
    instance = new(game)
    instance.draw
    gets
    nil
  end
end
