require './lib/chess'

describe GameTurnScreen do
  describe '#handle_input' do
    subject(:screen) { described_class.new(game) }

    let(:buffer_io) { BufferIO.new }
    let(:game) do
      Game.new([
                 Player.new('p1', :white),
                 Player.new('p2', :black)
               ],
               Board.new)
    end

    before do
      UserInterface.io = buffer_io
      allow(buffer_io).to receive(:clear)
    end

    context 'empty input' do
      it 'contain error string' do
        buffer_io.input_buffer.reopen("\n/quit\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'alphabet wrong input' do
      it 'contain error string' do
        buffer_io.input_buffer.reopen("test\n/quit\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'number wrong input' do
      it 'contain error string' do
        buffer_io.input_buffer.reopen("1234\n/quit\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'symbols wrong input' do
      it 'contain error string' do
        buffer_io.input_buffer.reopen("?*_-=\n/quit\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input is command starts with slash(/)' do
      let(:filter) { TurnHandlerCommand.create_filter(game) }

      before do
        screen.instance_variable_get(:@input).instance_variable_get(:@filters)[1] = filter
      end

      context 'command is empty' do
        before do
          allow(buffer_io).to receive(:readline).and_return('/', '/quit')
        end

        it 'contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).to match(/error/)
        end
      end

      context 'command is save' do
        before do
          allow(SerializeScreen).to receive(:show_and_read)
          allow(buffer_io).to receive(:readline).and_return('/save', '/quit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return nil' do
          expect(screen.handle_input).to be_nil
        end

        it 'call save method once' do
          screen.handle_input
          expect(SerializeScreen).to have_received(:show_and_read).with(:save, game: game).once
        end
      end

      context 'command is export' do
        before do
          allow(SerializeScreen).to receive(:show_and_read)
          allow(buffer_io).to receive(:readline).and_return('/export', '/quit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return nil' do
          expect(screen.handle_input).to be_nil
        end

        it 'call export method once' do
          screen.handle_input
          expect(SerializeScreen).to have_received(:show_and_read).with(:export, game: game).once
        end
      end

      context 'command is history' do
        before do
          allow(TurnHistoryScreen).to receive(:show)
          allow(buffer_io).to receive(:readline).and_return('/history', '/quit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return nil' do
          expect(screen.handle_input).to be_nil
        end

        it 'call history method once' do
          screen.handle_input
          expect(TurnHistoryScreen).to have_received(:show).once
        end
      end

      context 'command is help' do
        before do
          allow(CommandHelpScreen).to receive(:show)
          allow(buffer_io).to receive(:readline).and_return('/help', '/quit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return nil' do
          expect(screen.handle_input).to be_nil
        end

        it 'call help method once' do
          screen.handle_input
          expect(CommandHelpScreen).to have_received(:show).once
        end
      end

      context 'command is draw' do
        let(:handler) { TurnHandlerCommand.new(game, 'draw') }

        before do
          allow(TurnHandlerCommand).to receive(:new).and_return(handler)
          allow(handler).to receive(:handle_input_command_draw)
          allow(buffer_io).to receive(:readline).and_return('/draw', '/quit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return nil' do
          expect(screen.handle_input).to be_nil
        end

        it 'call draw method once' do
          screen.handle_input
          expect(handler).to have_received(:handle_input_command_draw).once
        end
      end

      context 'command is surrender' do
        let(:handler) { TurnHandlerCommand.new(game, 'surrender') }

        before do
          allow(TurnHandlerCommand).to receive(:new).and_return(handler)
          allow(handler).to receive(:handle_input_command_surrender)
          allow(buffer_io).to receive(:readline).and_return('/surrender', '/quit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return nil' do
          expect(screen.handle_input).to be_nil
        end

        it 'call surrender method once' do
          screen.handle_input
          expect(handler).to have_received(:handle_input_command_surrender).once
        end
      end

      context 'command is sur' do
        let(:handler) { TurnHandlerCommand.new(game, 'sur') }

        before do
          allow(TurnHandlerCommand).to receive(:new).and_return(handler)
          allow(handler).to receive(:handle_input_command_surrender)
          allow(buffer_io).to receive(:readline).and_return('/sur', '/quit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return nil' do
          expect(screen.handle_input).to be_nil
        end

        it 'call surrender method once' do
          screen.handle_input
          expect(handler).to have_received(:handle_input_command_surrender).once
        end
      end

      context 'command is mm' do
        before do
          allow(buffer_io).to receive(:readline).and_return('/mm', '/quit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return command symbol :main_menu' do
          expect(screen.handle_input).to be(:main_menu)
        end
      end

      context 'command is menu' do
        before do
          allow(buffer_io).to receive(:readline).and_return('/menu', '/quit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return command symbol :main_menu' do
          expect(screen.handle_input).to be(:main_menu)
        end
      end

      context 'command is quit' do
        before do
          allow(buffer_io).to receive(:readline).and_return('/quit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return command symbol :quit' do
          expect(screen.handle_input).to be(:quit)
        end
      end

      context 'command is exit' do
        before do
          allow(buffer_io).to receive(:readline).and_return('/exit')
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return command symbol :quit' do
          expect(screen.handle_input).to be(:quit)
        end
      end
    end

    context 'input is simple move a2 a4' do
      before do
        allow(buffer_io).to receive(:readline).and_return('a2 a4', '/quit')
      end

      context 'it is possible move' do
        let(:move) do
          start_point = Coordinate.new(0, 1)
          Move.new(game.board.at(start_point), start_point, Coordinate.new(0, 3))
        end

        before do
          screen.instance_variable_get(:@input).instance_variable_get(:@filters)[0] =
            TurnHandlerSimpleMove.create_filter(game, [move])
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return nil' do
          expect(screen.handle_input).to be_nil
        end

        it 'call perform movement from game once' do
          allow(game.board).to receive(:move!)
          screen.handle_input
          expect(game.board).to have_received(:move!).with(move).once
        end
      end

      context 'it is impossible move' do
        let(:move) do
          start_point = Coordinate.new(0, 1)
          Move.new(game.board.at(start_point), start_point, Coordinate.new(0, 3))
        end

        before do
          screen.instance_variable_get(:@input).instance_variable_get(:@filters)[0] =
            TurnHandlerSimpleMove.create_filter(game, [])
        end

        it 'contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).to match(/error/)
        end

        it 'never call perform movement from game' do
          allow(game.board).to receive(:move!)
          screen.handle_input
          expect(game.board).not_to have_received(:move!)
        end
      end
    end

    context 'input is special move 1' do
      before do
        allow(buffer_io).to receive(:readline).and_return('s 1', '/quit')
      end

      context 'it is possible move' do
        let(:move) do
          EnPassant.new(
            Figure.new(:pawn, :white), Coordinate.new(0, 1), Coordinate.new(0, 3),
            Figure.new(:pawn, :black), Coordinate.new(0, 2)
          )
        end

        before do
          screen.instance_variable_get(:@input).instance_variable_get(:@filters)[2] =
            TurnHandlerSpecialMove.create_filter(game, [move])
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return nil' do
          expect(screen.handle_input).to be_nil
        end

        it 'call perform movement from game once' do
          allow(game.board).to receive(:move!)
          screen.handle_input
          expect(game.board).to have_received(:move!).with(move).once
        end
      end

      context 'it is impossible move' do
        let(:move) do
          EnPassant.new(
            Figure.new(:pawn, :white), Coordinate.new(0, 1), Coordinate.new(0, 3),
            Figure.new(:pawn, :black), Coordinate.new(0, 2)
          )
        end

        before do
          screen.instance_variable_get(:@input).instance_variable_get(:@filters)[2] =
            TurnHandlerSpecialMove.create_filter(game, [])
        end

        it 'contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).to match(/error/)
        end

        it 'never call perform movement from game' do
          allow(game.board).to receive(:move!)
          screen.handle_input
          expect(game.board).not_to have_received(:move!).with(move)
        end
      end
    end

    context 'input is notation move a2 a4' do
      before do
        allow(buffer_io).to receive(:readline).and_return('a4', '/quit')
      end

      context 'it is possible move' do
        let(:move) do
          start_point = Coordinate.new(0, 1)
          Move.new(game.board.at(start_point), start_point, Coordinate.new(0, 3))
        end

        before do
          screen.instance_variable_get(:@input).instance_variable_get(:@filters)[3] =
            TurnHandlerNotationMove.create_filter(game, [move])
        end

        it 'not contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).not_to match(/error/)
        end

        it 'return nil' do
          expect(screen.handle_input).to be_nil
        end

        it 'call perform movement from game once' do
          allow(game.board).to receive(:move!)
          screen.handle_input
          expect(game.board).to have_received(:move!).with(move).once
        end
      end

      context 'it is impossible move' do
        let(:move) do
          start_point = Coordinate.new(0, 1)
          Move.new(game.board.at(start_point), start_point, Coordinate.new(0, 3))
        end

        before do
          screen.instance_variable_get(:@input).instance_variable_get(:@filters)[3] =
            TurnHandlerNotationMove.create_filter(game, [])
        end

        it 'contain error string' do
          screen.handle_input
          expect(buffer_io.output_buffer.string).to match(/error/)
        end

        it 'never call perform movement from game' do
          allow(game.board).to receive(:move!)
          screen.handle_input
          expect(game.board).not_to have_received(:move!)
        end
      end
    end
  end
end
