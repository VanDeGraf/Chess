require './lib/game'

class Chess
  def initialize
    @game = nil
  end

  def start
    await_main_menu_command
    Console.update
  end

  # @return [Void]
  def await_main_menu_command
    command = View.main_menu do |command|
      case command
      when :play_human_vs_computer
        Console.popup_message('Sorry, this feature not implemented yet!')
      when :play_computer_vs_computer
        Console.popup_message('Sorry, this feature not implemented yet!')
      when :import_from_PGN
        Console.popup_message('Sorry, this feature not implemented yet!')
      when :rules
        Console.popup_message('Sorry, this feature not implemented yet!')
      when :cmd_help
        Console.popup_message('Sorry, this feature not implemented yet!')
      else
        nil
      end
    end
    case command
    when :play_human_vs_human
      @game = Game.new
      await_play_game_command
    when :load_game
      save_name = View.save_name_input { |save_name| File.exist?(Game.full_name_of_save_file(save_name)) }
      @game = Game.load(save_name)
      await_play_game_command
    end
  end

  # @return [Void]
  def await_play_game_command
    end_game_command = @game.play_game do |in_game_command|
      case in_game_command
      when :save_game
        save_name = View.save_name_input
        @game.save(save_name)
        Console.popup_message("Game saved successfully to #{Game.full_name_of_save_file(save_name)}")
      when :export_to_PGN
        Console.popup_message('Sorry, this feature not implemented yet!')
      when :show_history
        Console.popup_message('Sorry, this feature not implemented yet!')
      when :draw
        Console.popup_message('Sorry, this feature not implemented yet!')
      when :surrender
        Console.popup_message('Sorry, this feature not implemented yet!')
      when :rules
        Console.popup_message('Sorry, this feature not implemented yet!')
      when :cmd_help
        Console.popup_message('Sorry, this feature not implemented yet!')
      else
        nil
      end
    end
    case end_game_command
    when :main_menu
      await_main_menu_command
    end
  end
end

# Chess.new.start
