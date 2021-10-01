require './lib/board'

describe Castling do
  let(:short_castling) { described_class.new(nil, nil, nil, nil, nil, nil, true) }
  let(:long_castling) { described_class.new(nil, nil, nil, nil, nil, nil, false) }

  describe '#to_s' do
    it 'short_castling returns right string' do
      expect(short_castling.to_s).to eql('castling short')
    end

    it 'long_castling returns right string' do
      expect(long_castling.to_s).to eql('castling long')
    end
  end

  describe '#special?' do
    it 'is' do
      expect(short_castling).to be_special
    end
  end

  describe '#algebraic_notation' do
    it 'short_castling returns right string' do
      expect(short_castling.algebraic_notation).to eql('O-O')
    end

    it 'long_castling returns right string' do
      expect(long_castling.algebraic_notation).to eql('O-O-O')
    end
  end

  describe '#perform_movement' do
    subject(:castling) do
      described_class.new(king_figure, rook_figure, king_point_start, king_point_end, rook_point_start, rook_point_end,
                          true)
    end

    let(:king_figure) { Figure.new(:king, :white) }
    let(:king_point_start) { Coordinate.new(0, 0) }
    let(:king_point_end) { Coordinate.new(1, 0) }
    let(:rook_figure) { Figure.new(:rook, :white) }
    let(:rook_point_start) { Coordinate.new(2, 0) }
    let(:rook_point_end) { Coordinate.new(3, 0) }

    let(:board) { Board.new }

    before do
      allow(board).to receive(:remove_at!)
      allow(board).to receive(:replace_at!)
    end

    it 'remove king from old position' do
      castling.perform_movement(board)
      expect(board).to have_received(:remove_at!).with(king_point_start)
    end

    it 'set king to new position' do
      castling.perform_movement(board)
      expect(board).to have_received(:replace_at!).with(king_point_end, king_figure)
    end

    it 'remove rook from old position' do
      castling.perform_movement(board)
      expect(board).to have_received(:remove_at!).with(rook_point_start)
    end

    it 'set rook to new position' do
      castling.perform_movement(board)
      expect(board).to have_received(:replace_at!).with(rook_point_end, rook_figure)
    end

    it 'returns nil, because nothing was eaten' do
      expect(castling.perform_movement(board)).to be_nil
    end
  end
end
