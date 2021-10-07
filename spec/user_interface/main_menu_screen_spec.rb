require './lib/chess'

describe MainMenuScreen do
  describe '#handle_input' do
    subject(:screen) { described_class.new }

    let(:buffer_io) { BufferIO.new }

    before do
      UserInterface.io = buffer_io
    end

    context 'empty input' do
      it 'contain error string' do
        allow(buffer_io).to receive(:clear)
        buffer_io.input_buffer.reopen("\n6\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input: 0' do
      it 'contain error string' do
        allow(buffer_io).to receive(:clear)
        buffer_io.input_buffer.reopen("0\n6\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input: 7' do
      it 'contain error string' do
        allow(buffer_io).to receive(:clear)
        buffer_io.input_buffer.reopen("7\n6\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input: abc' do
      it 'contain error string' do
        allow(buffer_io).to receive(:clear)
        buffer_io.input_buffer.reopen("abc\n6\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input: 123' do
      it 'contain error string' do
        allow(buffer_io).to receive(:clear)
        buffer_io.input_buffer.reopen("123\n6\n", 'a+')
        screen.handle_input
        expect(buffer_io.output_buffer.string).to match(/error/)
      end
    end

    context 'input: 1' do
      it 'return command symbol :play_human_vs_human' do
        buffer_io.input_buffer.reopen("1\n6\n", 'a+')
        expect(screen.handle_input).to be(:play_human_vs_human)
      end
    end

    context 'input: 2' do
      it 'return command symbol :play_human_vs_computer' do
        buffer_io.input_buffer.reopen("2\n6\n", 'a+')
        expect(screen.handle_input).to be(:play_human_vs_computer)
      end
    end

    context 'input: 3' do
      it 'return command symbol :load_game' do
        buffer_io.input_buffer.reopen("3\n6\n", 'a+')
        expect(screen.handle_input).to be(:load_game)
      end
    end

    context 'input: 4' do
      it 'return command symbol :import_from_PGN' do
        buffer_io.input_buffer.reopen("4\n6\n", 'a+')
        expect(screen.handle_input).to be(:import_from_PGN)
      end
    end

    context 'input: 5' do
      it 'show help screen ' do
        allow(buffer_io).to receive(:clear)
        allow(CommandHelpScreen).to receive(:show)
        buffer_io.input_buffer.reopen("5\n6\n", 'a+')
        screen.handle_input
        expect(CommandHelpScreen).to have_received(:show).once
      end
    end

    context 'input: 6' do
      it 'return command symbol :quit' do
        buffer_io.input_buffer.reopen("6\n", 'a+')
        expect(screen.handle_input).to be(:quit)
      end
    end
  end
end
