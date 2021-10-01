class TurnHandlerCommand < TurnHandler
  def initialize(game, command)
    super()
    @game = game
    @command = command
  end

  def perform_action
    case @command
    when 'save'
      handle_input_command_save
    when 'export'
      handle_input_command_export
    when 'mm', 'menu'
      :main_menu
    when 'draw'
      handle_input_command_draw
    when 'surrender', 'sur'
      handle_input_command_surrender
    when 'history'
      TurnHistoryScreen.show(@game)
    when 'help'
      CommandHelpScreen.show
    when 'quit', 'exit'
      :quit
    end
  end

  def error_msg
    "Not found command with name: #{@command}"
  end

  def handle_input_command_draw
    if @game.opposite_player.is_a?(Computer)
      MessageScreen.show("Computer player can't accept your draw request!")
    elsif AcceptRequestScreen.show_and_read(
      "#{@game.current_player}, are you sure you want to offer a draw to your opponent?"
    ) && AcceptRequestScreen.show_and_read(
      "#{@game.current_player} wants to end the game in a draw, #{@game.opposite_player} do you agree?"
    )
      :draw
    end
  end

  def handle_input_command_surrender
    if @game.opposite_player.is_a?(Computer)
      MessageScreen.show("Computer player can't accept your surrender request!")
    elsif AcceptRequestScreen.show_and_read(
      "#{@game.current_player}, are you sure you want surrender?"
    ) && AcceptRequestScreen.show_and_read(
      "#{@game.current_player} wants surrender, #{@game.opposite_player} do you agree?"
    )
      :surrender
    end
  end

  def handle_input_command_save
    SaveLoadScreen.show_and_read(:save, game: @game)
    nil
  end

  def handle_input_command_export
    SaveLoadScreen.show_and_read(:export, game: @game)
    nil
  end

  # @param game [Game]
  def self.create_filter(game)
    InputFilter.new(%r{^(/([a-z]+) ?(\S* ?)*)$},
                    handler: proc { |match_data| new(game, match_data[2]) })
  end
end
