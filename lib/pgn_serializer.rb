class PGNSerializer < Serializer
  EXPORT_DIR = File.expand_path('../saves', __dir__).freeze

  def convert_to_string(game)
    tags_block(game) + turns_block(game)
  end

  def game_result(game)
    if game.finished
      if game.winner.nil?
        '1/2-1/2'
      else
        game.winner == game.players[0] ? '1-0' : '0-1'
      end
    else
      '*'
    end
  end

  def turns_block(game)
    block = StringIO.new
    row = StringIO.new
    game.board.history.each_with_index do |movement, i|
      if i.even?
        if row.length >= 80
          block << "#{row.string}\n"
          row = StringIO.new
        end
        row << "#{(i + 2) / 2}."
      end
      row << turn_string(board_history_before_iteration(game.board, i), movement)
    end
    row << " #{game_result(game)}" if game.finished
    block << row.string

    block.string
  end

  def board_history_before_iteration(board, iter)
    temp_board = Board.new
    board.history.each_with_index do |movement, i|
      break if i == iter

      temp_board.move!(movement)
    end
    temp_board
  end

  def tags_block(game)
    "[Event \"Game\"]\n" \
    "[Site \"?\"]\n" \
    "[Date \"????.??.??\"]\n" \
    "[Round \"?\"]\n" \
    "[White \"#{game.players[0].name}\"]\n" \
    "[Black \"#{game.players[1].name}\"]\n" \
    "[Result \"#{game_result(game)}\"]\n\n"
  end

  def turn_string(board, movement)
    current_color = if board.history.last.nil?
                      :white
                    elsif board.history.last.figure.color == :white
                      :black
                    else
                      :white
                    end
    player_turn = turn_string_prefix(board, current_color, movement)
    board.move!(movement)
    current_color = current_color == :white ? :black : :white
    postfix = turn_string_postfix(board, current_color)
    "#{player_turn}#{postfix} "
  end

  def turn_string_prefix(board, current_color, movement)
    possible_moves = board.possible_moves(current_color)
    assoc = MovementGenerator.algebraic_notation(possible_moves)
    assoc.each_pair do |string, move|
      next if move != movement

      return string
    end
  end

  def turn_string_postfix(board, current_color)
    if board.state.mate?(current_color)
      '#'
    elsif board.state.shah?(current_color)
      '+'
    else
      ''
    end
  end

  def convert_from_string(data)
    tabs = data.delete("\r").split("\n\n")
    saves = []
    tabs.each_index do |i|
      next unless i.odd?

      game = init_game(parse_tags_block(tabs[i - 1]))
      parse_turns_block(game, tabs[i])
      saves << game
    end
    return saves.last if saves.size == 1

    saves
  end

  def parse_tags_block(data)
    tags = {}
    re = /\[(\w+) "([^"]*)"\]/m
    data.scan(re) do |match|
      tags[match[0]] = match[1]
    end
    tags
  end

  def init_game(tags)
    game = Game.new([
                      Player.new(tags['White'], :white),
                      Player.new(tags['Black'], :black)
                    ])
    if tags['Result'] == '*'
      game.instance_variable_set(:@finished, false)
      game.instance_variable_set(:@winner, nil)
    else
      game.instance_variable_set(:@finished, true)
      winner = case tags['Result']
               when '1-0'
                 game.instance_variable_get(:@players)[0]
               when '0-1'
                 game.instance_variable_get(:@players)[1]
               end
      game.instance_variable_set(:@winner, winner)
    end
    game
  end

  # @return [Void]
  def parse_turns_block(game, data)
    re = /([BNQKR]?[a-h]?[1-8]?x?[a-h][1-8]=?[BNQKR]?)|(O-O)|(O-O-O)/m
    data.scan(re) do |m|
      string_move = "#{m[0]}#{m[1]}#{m[2]}"

      possible_moves = game.board.possible_moves(game.current_player.color)

      move = MovementGenerator.algebraic_notation(possible_moves)[string_move]
      game.board.move!(move)

      game.instance_variable_set(:@current_player, game.instance_variable_get(:@current_player).zero? ? 1 : 0)
    end
  end

  def filepath(filename)
    "#{super}.pgn"
  end

  def file_directory
    EXPORT_DIR
  end
end
