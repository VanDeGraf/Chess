class GameEndScreen < Screen
  def initialize(game)
    menu_actions = [
      MenuAction.new(:show_history, 'Show turns history'),
      MenuAction.new(:save_game, 'Save this game'),
      MenuAction.new(:export_to_PGN, 'Export this game'),
      MenuAction.new(:main_menu, 'Go to Main Menu'),
      MenuAction.new(:quit, 'Exit from the program')
    ]
    super('Game is over!', input: ScreenMenuInput.new(self, menu_actions))
    @game = game
  end

  def self.show_and_read(game)
    instance = new(game)
    instance.draw
    instance.handle_input
  end

  # @return [Symbol]
  def handle_input
    command = nil
    while command.nil?
      command = perform_command(@input.handle_console_input)
      draw
    end
    command
  end

  # @return [Symbol, nil]
  def perform_command(command)
    return command unless %i[show_history save_game export_to_PGN].include?(command)

    if command.eql?(:show_history)
      TurnHistoryScreen.show(@game)
    else
      screen_type = command.eql?(:save_game) ? :save : :export
      SerializeScreen.show_and_read(screen_type, game: @game)
    end
    nil
  end

  def draw
    UserInterface.io.clear
    UserInterface.io.write "\t#{@header}\n"
    UserInterface.draw_board(@game.board)
    UserInterface.io.writeline(game_result)
    UserInterface.io.write @input.draw unless @input.nil?
  end

  def game_result
    if @game.winner.nil?
      "\nDraw! No winners!"
    else
      "\nPlayer #{@game.winner} Win! Congratulations!"
    end
  end
end
