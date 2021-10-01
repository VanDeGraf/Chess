require './lib/board'

describe EnPassant do
  subject(:en_passant) { described_class.new(figure1, point_start, point_end, figure2, point_capture) }

  let(:figure1) { Figure.new(:pawn, :black) }
  let(:figure2) { Figure.new(:pawn, :white) }
  let(:point_start) { Coordinate.new(1, 3) }
  let(:point_end) { Coordinate.new(0, 2) }
  let(:point_capture) { Coordinate.new(0, 3) }

  describe '#to_s' do
    it 'returns right string' do
      expect(en_passant.to_s).to eql('en passant from b4 to a3')
    end
  end

  describe '#special?' do
    it 'is' do
      expect(en_passant).to be_special
    end
  end

  describe '#algebraic_notation' do
    it 'returns right string' do
      expect(en_passant.algebraic_notation).to eql('bxa3')
    end
  end

  describe '#perform_movement' do
    subject(:en_passant) do
      described_class.new(figure, point_start, point_end, Figure.new(:pawn, :black), captured_at)
    end

    let(:figure) { Figure.new(:pawn, :white) }
    let(:point_start) { Coordinate.new(0, 0) }
    let(:point_end) { Coordinate.new(1, 0) }
    let(:captured_at) { Coordinate.new(2, 0) }

    let(:board) { Board.new }

    before do
      allow(board).to receive(:remove_at!)
      allow(board).to receive(:replace_at!)
    end

    it 'remove figure from old position' do
      en_passant.perform_movement(board)
      expect(board).to have_received(:remove_at!).with(point_start)
    end

    it 'set figure to new position' do
      en_passant.perform_movement(board)
      expect(board).to have_received(:replace_at!).with(point_end, figure)
    end

    it 'remove captured figure' do
      en_passant.perform_movement(board)
      expect(board).to have_received(:remove_at!).with(captured_at)
    end
  end
end
