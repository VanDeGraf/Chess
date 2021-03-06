require_relative 'turn_handler'
require_relative 'turn_handler_simple_move'
require_relative 'turn_handler_command'
require_relative 'turn_handler_special_move'
require_relative 'turn_handler_notation_move'

class GameTurnScreen < Screen
  def initialize(game)
    @game = game
    @default_moves = []
    @special_moves = []
    init_moves
    super('Chess Game Turn', input: init_input_params)
  end

  def init_moves
    @game.board.possible_moves(@game.current_player.color).each do |move|
      if move.special?
        @special_moves << move
      else
        @default_moves << move
      end
    end
  end

  def init_input_params
    ScreenDataInput.new(self,
                        'Enter your move or command',
                        filters: [
                          TurnHandlerSimpleMove.create_filter(@game, @default_moves),
                          TurnHandlerCommand.create_filter(@game),
                          TurnHandlerSpecialMove.create_filter(@game, @special_moves),
                          TurnHandlerNotationMove.create_filter(@game, @default_moves + @special_moves)
                        ],
                        default_errmsg: "Can't parse inputted string, enter /help for more info about input.")
  end

  def self.show_and_read(game)
    instance = new(game)
    instance.draw
    instance.handle_input
  end

  def draw
    UserInterface.io.clear
    UserInterface.io.write "\t#{@header}\n"
    UserInterface.draw_board(@game.board)
    draw_special_moves_block unless @special_moves.empty?
    UserInterface.io.writeline "Player #{@game.current_player} turn."
    UserInterface.io.writeline @input.draw unless @game.current_player.is_a?(Computer)
  end

  def draw_special_moves_block
    UserInterface.io.writeline 'You can do one of this special moves: '
    @special_moves.each_with_index { |move, i| UserInterface.io.writeline "#{i + 1}) #{move}" }
  end

  # @return [Symbol,nil]
  def handle_input
    loop do
      # @type [TurnHandler]
      action = @input.handle_console_input
      command = action.perform_action
      @input.error_message = action.error_msg if action.has_error
      draw
      return command unless action.has_error
    end
    nil
  end
end
