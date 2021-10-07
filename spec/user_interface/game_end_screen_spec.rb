require './lib/chess'

describe GameEndScreen do
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
        buffer_io.input_buffer.reopen("\n5\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input: 0' do
      it 'contain error string' do
        buffer_io.input_buffer.reopen("0\n5\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input: 6' do
      it 'contain error string' do
        buffer_io.input_buffer.reopen("6\n5\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input: abc' do
      it 'contain error string' do
        buffer_io.input_buffer.reopen("abc\n5\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input: 123' do
      it 'contain error string' do
        buffer_io.input_buffer.reopen("123\n5\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input: 1' do
      it 'show history screen once' do
        allow(TurnHistoryScreen).to receive(:show)
        buffer_io.input_buffer.reopen("1\n5\n", 'a+')
        screen.handle_input
        expect(TurnHistoryScreen).to have_received(:show).once
      end
    end

    context 'input: 2' do
      it 'show save serialize screen once' do
        allow(SerializeScreen).to receive(:show_and_read)
        buffer_io.input_buffer.reopen("2\n5\n", 'a+')
        screen.handle_input
        expect(SerializeScreen).to have_received(:show_and_read).with(:save, game: game).once
      end
    end

    context 'input: 3' do
      it 'show export serialize screen once' do
        allow(SerializeScreen).to receive(:show_and_read)
        buffer_io.input_buffer.reopen("3\n5\n", 'a+')
        screen.handle_input
        expect(SerializeScreen).to have_received(:show_and_read).with(:export, game: game).once
      end
    end

    context 'input: 4' do
      it 'return command symbol :main_menu' do
        buffer_io.input_buffer.reopen("4\n", 'a+')
        expect(screen.handle_input).to be(:main_menu)
      end
    end

    context 'input: 5' do
      it 'return command symbol :quit' do
        buffer_io.input_buffer.reopen("5\n", 'a+')
        expect(screen.handle_input).to be(:quit)
      end
    end
  end
end
