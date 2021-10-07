require './lib/chess'

describe AcceptRequestScreen do
  describe '#handle_input' do
    subject(:screen) { described_class.new('') }

    let(:buffer_io) { BufferIO.new }

    before do
      UserInterface.io = buffer_io
    end

    context 'empty input' do
      it 'wait user input again' do
        allow(buffer_io).to receive(:readline).and_return('', 'y')
        screen.handle_input
        expect(buffer_io).to have_received(:readline).twice
      end
    end

    context 'not y or n' do
      it 'wait user input again on numbers' do
        allow(buffer_io).to receive(:readline).and_return('123', 'y')
        screen.handle_input
        expect(buffer_io).to have_received(:readline).twice
      end

      it 'wait user input again on letters' do
        allow(buffer_io).to receive(:readline).and_return('abc', 'y')
        screen.handle_input
        expect(buffer_io).to have_received(:readline).twice
      end

      it 'wait user input again on symbols' do
        allow(buffer_io).to receive(:readline).and_return('_+', 'y')
        screen.handle_input
        expect(buffer_io).to have_received(:readline).twice
      end
    end

    context 'y' do
      it 'return true' do
        buffer_io.input_buffer.reopen("y\n", 'a+')
        expect(screen.handle_input).to be_truthy
      end
    end

    context 'n' do
      it 'return false' do
        buffer_io.input_buffer.reopen("n\n", 'a+')
        expect(screen.handle_input).to be_falsey
      end
    end
  end
end
