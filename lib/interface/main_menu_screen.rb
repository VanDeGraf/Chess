class MainMenuScreen < Screen
  def initialize
    menu_actions = [
      MenuAction.new(:play_human_vs_human, 'Play game Human vs Human'),
      MenuAction.new(:play_human_vs_computer, 'Play game Human vs Computer'),
      MenuAction.new(:load_game, 'Load saved game'),
      MenuAction.new(:import_from_PGN, 'Import game save from PGN format file and load it'),
      MenuAction.new(:cmd_help, 'Show in game console commands'),
      MenuAction.new(:quit, 'Exit from the program')
    ]
    super('Main Menu', input: ScreenMenuInput.new(menu_actions))
  end

  # @return [Symbol]
  def self.show_and_read
    instance = new
    instance.draw
    instance.handle_input
  end


  def handle_input
    loop do
      command = @input.handle_console_input { |_| draw }
      case command
      when :play_human_vs_computer
        MessageScreen.show('Sorry, this feature not implemented yet!')
      when :import_from_PGN
        MessageScreen.show('Sorry, this feature not implemented yet!')
      when :cmd_help
        CommandHelpScreen.show
      else
        return command
      end
      draw
    end
  end
end