require './lib/game'

class Chess

  def initialize
    @game = nil
  end

  def start
    case_main_menu_command
  end

  # @return [Void]
  def case_main_menu_command
    case View.main_menu
    when 1
      @game = Game.new
      case_end_menu_command(@game.play_game)
    end
  end

  # @return [Void]
  def case_end_menu_command(command_number)
    case command_number
    when 1
      case_main_menu_command
    end
  end
end

# Chess.new.start
