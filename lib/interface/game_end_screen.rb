class GameEndScreen < Screen
  def initialize(game)
    menu_actions = [
      MenuAction.new(:show_history, 'Show turns history'),
      MenuAction.new(:save_game, 'Save this game'),
      MenuAction.new(:export_to_PGN, 'Export this game'),
      MenuAction.new(:main_menu, 'Go to Main Menu'),
      MenuAction.new(:quit, 'Exit from the program')
    ]
    super('Game is over!', input: ScreenMenuInput.new(menu_actions))
    @game = game
  end

  def self.show_and_read(game)
    instance = new(game)
    instance.draw
    instance.handle_input
  end

  # @return [Symbol]
  def handle_input
    loop do
      command = @input.handle_console_input { |_| draw }
      case command
      when :show_history
        MessageScreen.show('Sorry, this feature not implemented yet!')
      when :save_game
        SaveLoadScreen.show_and_read(:save, game: @game)
      when :export_to_PGN
        MessageScreen.show('Sorry, this feature not implemented yet!')
      else
        return command
      end
      draw
    end
    :stub
  end

  def draw
    Interface.clear_console
    print "\t#{@header}\n"
    Interface.draw_board(@game.board)
    if @game.winner.nil?
      puts "\nDraw! No winners!"
    else
      puts "\nPlayer #{@game.winner} Win! Congratulations!"
    end
    print @input.draw unless @input.nil?
  end
end