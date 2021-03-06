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
      command = init_main_menu_await_command(returned_command)
      if command.eql?(:quit)
        UserInterface.io.clear
        break
      end
      perform_command_to_game(command)
      returned_command = await_play_game_command
    end
  end

  def init_main_menu_await_command(returned_command)
    if returned_command.nil? || returned_command == :main_menu
      MainMenuScreen.show_and_read
    else
      returned_command
    end
  end

  def perform_command_to_game(command)
    @game = case command
            when :play_human_vs_human
              Game.new
            when :play_human_vs_computer
              Game.new([nil, Computer.new(:black)])
            when :load_game
              SerializeScreen.show_and_read(:load)
            when :import_from_PGN
              SerializeScreen.show_and_read(:import)
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
