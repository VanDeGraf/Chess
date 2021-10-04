require './lib/board'

describe CastlingGenerator do
  describe '#king_moves_ever?' do
    let(:color) { :white }

    context 'king not on board' do
      subject(:generator) { described_class.new(board, color) }

      let(:board) do
        b = Board.new
        b.instance_variable_set(:@board, Array.new(8) { Array.new(8) })
        b
      end

      it 'return true' do
        expect(generator).to be_king_moves_ever
      end
    end

    context 'king on board' do
      let(:board) { Board.new }

      context 'exists king move in history' do
        it 'return true' do
          board.move!(Move.new(Figure.new(:king, color), Coordinate.new(0, 3), Coordinate.new(2, 3)))
          expect(described_class.new(board, color)).to be_king_moves_ever
        end
      end

      context 'dont exists king move in history' do
        it 'return false' do
          expect(described_class.new(board, color)).not_to be_king_moves_ever
        end
      end
    end
  end

  describe '#rook_moves_ever?' do
    let(:color) { :white }
    let(:rook_start_point) { Coordinate.new(0, 0) }

    context 'rook has move in history' do
      let(:board) do
        b = Board.new
        b.move!(Move.new(Figure.new(:rook, color), rook_start_point, Coordinate.new(0, 5)))
        b
      end

      it 'return true' do
        expect(described_class.new(board, color)).to be_rook_moves_ever(rook_start_point)
      end
    end

    context 'rook not has move in history' do
      let(:board) { Board.new }

      context 'rook not exists' do
        it 'return true' do
          board.remove_at!(rook_start_point)
          expect(described_class.new(board, color)).to be_rook_moves_ever(rook_start_point)
        end
      end

      context 'rook exists' do
        it 'return false' do
          expect(described_class.new(board, color)).not_to be_rook_moves_ever(rook_start_point)
        end
      end
    end
  end

  describe '#king_path_on_shah?' do
    let(:color) { :white }
    let(:opposite_color) { :black }
    let(:board) do
      b = Board.new
      b.instance_variable_set(:@board, Array.new(8) { Array.new(8) })
      b.replace_at!(Coordinate.new(3, 0), Figure.new(:king, color))
      b
    end
    let(:side_direction) { -1 }

    context 'all path clear' do
      it 'return false' do
        expect(described_class.new(board, color)).not_to be_king_path_on_shah(side_direction)
      end
    end

    context 'king on shah now' do
      it 'return true' do
        board.replace_at!(Coordinate.new(3, 1), Figure.new(:rook, opposite_color))
        expect(described_class.new(board, color)).to be_king_path_on_shah(side_direction)
      end
    end

    context 'cell 1 of path on shah' do
      it 'return true' do
        board.replace_at!(Coordinate.new(2, 1), Figure.new(:rook, opposite_color))
        expect(described_class.new(board, color)).to be_king_path_on_shah(side_direction)
      end
    end

    context 'cell 2 of path on shah' do
      it 'return true' do
        board.replace_at!(Coordinate.new(1, 1), Figure.new(:rook, opposite_color))
        expect(described_class.new(board, color)).to be_king_path_on_shah(side_direction)
      end
    end
  end

  describe '#generate_side' do
    subject(:generator) { described_class.new(Board.new, :white) }

    let(:side) { :castling_short }

    before do
      allow(generator).to receive(:castling_instance).and_return(true)
    end

    context 'king_moves_ever? is true' do
      it 'return nil' do
        allow(generator).to receive(:king_moves_ever?).and_return(true)
        expect(generator.generate_side(side)).to be_nil
      end
    end

    context 'king_moves_ever? is false' do
      before do
        allow(generator).to receive(:king_moves_ever?).and_return(false)
      end

      context 'path_between_pieces_clear? is false' do
        it 'return nil' do
          allow(generator).to receive(:path_between_pieces_clear?).and_return(false)
          expect(generator.generate_side(side)).to be_nil
        end
      end

      context 'path_between_pieces_clear? is true' do
        before do
          allow(generator).to receive(:path_between_pieces_clear?).and_return(true)
        end

        context 'rook_moves_ever? is true' do
          it 'return nil' do
            allow(generator).to receive(:rook_moves_ever?).and_return(true)
            expect(generator.generate_side(side)).to be_nil
          end
        end

        context 'rook_moves_ever? is false' do
          before do
            allow(generator).to receive(:rook_moves_ever?).and_return(false)
          end

          context 'king_path_on_shah? is true' do
            it 'return nil' do
              allow(generator).to receive(:king_path_on_shah?).and_return(true)
              expect(generator.generate_side(side)).to be_nil
            end
          end

          context 'king_path_on_shah? is false' do
            it 'return not nil' do
              allow(generator).to receive(:king_path_on_shah?).and_return(false)
              expect(generator.generate_side(side)).not_to be_nil
            end
          end
        end
      end
    end
  end

  describe '#castling_instance' do
    subject(:generator) { described_class.new(board, color) }

    let(:board) { Board.new }
    let(:color) { :white }

    context 'side direction is positive' do
      let(:side_direction) { 1 }
      let(:rook_start_point) { Coordinate.new(7, 0) }

      it 'set king_point_end at coordinate 6,0' do
        expect(generator.castling_instance(side_direction, rook_start_point).king_point_end)
          .to eq(Coordinate.new(6, 0))
      end

      it 'set rook_point_end at coordinate 5,0' do
        expect(generator.castling_instance(side_direction, rook_start_point).rook_point_end)
          .to eq(Coordinate.new(5, 0))
      end

      it 'set short true' do
        expect(generator.castling_instance(side_direction, rook_start_point).short)
          .to be_truthy
      end
    end

    context 'side direction is negative' do
      let(:side_direction) { -1 }
      let(:rook_start_point) { Coordinate.new(0, 0) }

      it 'set king_point_end at coordinate 2,0' do
        expect(generator.castling_instance(side_direction, rook_start_point).king_point_end)
          .to eq(Coordinate.new(2, 0))
      end

      it 'set rook_point_end at coordinate 3,0' do
        expect(generator.castling_instance(side_direction, rook_start_point).rook_point_end)
          .to eq(Coordinate.new(3, 0))
      end

      it 'set short false' do
        expect(generator.castling_instance(side_direction, rook_start_point).short)
          .to be_falsey
      end
    end
  end
end
