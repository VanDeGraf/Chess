require './lib/console'

module View
  def self.main_menu
    options = {
      screen: :main_menu,
      header: 'Main Menu',
      input: {
        actions: [
          { delimiter: '' },
          { play_human_vs_human: 'Play game Human vs Human' },
          { play_human_vs_computer: 'Play game Human vs Computer' },
          { play_computer_vs_computer: 'Play game Computer vs Computer' },
          { delimiter: '' },
          { load_game: 'Load saved game' },
          { import_from_PGN: 'Import game save from PGN format file and load it' },
          { delimiter: '' },
          { rules: 'Show chess game rules' },
          { cmd_help: 'Show in game console commands' },
          { delimiter: '' },
          { quit: 'Exit from the program' },
          { delimiter: '' }
        ],
        description_message: 'Enter the number of the action you would like to perform: ',
        error_message: nil
      }
    }
    Console.update(options)
    until yield((command = Console.menu_input(options))).nil?
      Console.update(options)
    end
    command
  end

  # @param game [Game]
  # @return [Move, Symbol]
  def self.game_turn(game)
    possible_moves = game.board.where_is(nil, game.current_player.color).map do |coordinate|
      MovesGenerator.generate_from(coordinate, game.board)
    end
    default_moves = []
    special_moves = MovesGenerator.castling(game.board, game.current_player.color)
    possible_moves.flatten.each do |move|
      if move.kind == :move || move.kind == :capture
        default_moves << move
      else
        special_moves << move
      end
    end
    options = {
      screen: :game_turn,
      game: game,
      input: {
        description_message: 'Type your figure coordinate and endpoint coordinate [a1 a1], ' \
                                'special move with s and number [s 1] or command [/help]',
        error_message: nil
      }
    }
    unless special_moves.empty?
      options[:special_moves] = {
        description_message: 'You can do one of this special moves: '
      }
      options[:special_moves][:moves] = special_moves.map do |move|
        case move.kind
        when :en_passant
          "en passant from #{move.options[:point_start]} to #{move.options[:point_end]}"
        when :promotion_move
          "pawn move to #{move.options[:point_end]} and promotion to #{move.options[:promoted_to].figure}"
        when :promotion_capture
          "pawn capture enemy at #{move.options[:point_end]} and promotion to #{move.options[:promoted_to].figure}"
        when :castling_short
          'castling short'
        when :castling_long
          'castling long'
        end
      end
    end
    Console.update(options)
    until (action = Console.player_turn_input(default_moves, special_moves, options))
      Console.update(options)
    end
    action
  end

  # @param game [Game]
  def self.end_game(game)
    options = {
      screen: :end_game,
      game: game,
      input: {
        actions: [
          { show_history: 'Show turns history' },
          { save_game: 'Save this game' },
          { export_to_PGN: 'Export this game' },
          { main_menu: 'Go to Main Menu' },
          { quit: 'Exit from the program' }
        ],
        description_message: 'Enter the number of the action you would like to perform: ',
        error_message: nil
      }
    }
    Console.update(options)
    until yield((command = Console.menu_input(options))).nil?
      Console.update(options)
    end
    command
  end

  def self.player_welcome(color)
    options = {
      screen: :player_welcome,
      color: color,
      input: {
        description_message: "Player with #{color} figures, enter your name: ",
        error_message: nil
      }
    }
    Console.update(options)
    while !(name = Player.name_input_parse).nil? && name[:action] == :error
      options[:input][:error_message] = name[:msg]
      Console.update(options)
    end
    Player.new(name[:name], color)
  end

  def self.save_name_input
    options = {
      screen: :save_name_input,
      input: {
        filter: /^[a-zA-Z \d]+$/,
        description_message: 'Enter the name of save file: ',
        error_message: nil
      }
    }
    Console.update(options)
    until (save_name = Console.param_input(options)) &&
          (!block_given? || yield(save_name))
      options[:input][:error_message] = 'File read exception or not found!'
      Console.update(options)
    end
    save_name
  end
end
