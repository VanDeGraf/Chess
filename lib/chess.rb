require_relative 'game'

class Chess
  def initialize
    @game = nil
  end

  def start
    await_main_menu_command
  end

  # @return [Void]
  def await_main_menu_command
    returned_command = nil
    loop do
      command = if returned_command.nil?
                  MainMenuScreen.show_and_read
                else
                  returned_command
                end
      returned_command = nil
      case command
      when :play_human_vs_human
        @game = Game.new
        returned_command = await_play_game_command
      when :play_human_vs_computer
        @game = Game.new([nil, Computer.new(:black)])
        returned_command = await_play_game_command
      when :load_game
        @game = SaveLoadScreen.show_and_read(:load)
        returned_command = await_play_game_command
      when :import_from_PGN
        @game = SaveLoadScreen.show_and_read(:import)
        returned_command = await_play_game_command
      when :quit
        Interface.clear_console
        break
      end
    end
  end

  # @return [Symbol, nil]
  def await_play_game_command
    command = @game.play_game
    case command
    when nil
      await_end_game_command
    else
      command
    end
  end

  # @return [Symbol]
  def await_end_game_command
    GameEndScreen.show_and_read(@game)
  end
end
