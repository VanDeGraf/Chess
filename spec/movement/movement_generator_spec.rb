require './lib/board'

describe MovementGenerator do
  describe '#rank_file_required?' do
    context 'move is Castling' do
      it 'return false' do
        expect(described_class)
          .not_to be_rank_file_required(
            Castling.new(nil, nil, nil,
                         nil, nil, nil, nil), nil
          )
      end
    end

    context 'move is PromotionMove' do
      it 'return false' do
        expect(described_class)
          .not_to be_rank_file_required(
            PromotionMove.new(nil, nil, nil, nil), nil
          )
      end
    end

    context 'move is EnPassant' do
      it 'return false' do
        expect(described_class)
          .not_to be_rank_file_required(
            EnPassant.new(nil, nil, nil, nil, nil), nil
          )
      end
    end

    context 'move is Move' do
      context 'movement equal' do
        it 'return false' do
          move = Move.new(Figure.new(:pawn, :white), Coordinate.new(0, 0), Coordinate.new(1, 1))
          expect(described_class)
            .not_to be_rank_file_required(move, move)
        end
      end

      context 'movement has not same point end' do
        it 'return false' do
          move1 = Move.new(Figure.new(:pawn, :white), Coordinate.new(0, 0), Coordinate.new(1, 1))
          move2 = Move.new(Figure.new(:pawn, :white), Coordinate.new(0, 2), Coordinate.new(1, 0))
          expect(described_class)
            .not_to be_rank_file_required(move1, move2)
        end
      end

      context 'movement has same point end' do
        context 'movement has same figure type' do
          it 'return true' do
            move1 = Move.new(Figure.new(:pawn, :white), Coordinate.new(0, 0), Coordinate.new(1, 1))
            move2 = Move.new(Figure.new(:pawn, :white), Coordinate.new(0, 2), Coordinate.new(1, 1))
            expect(described_class)
              .to be_rank_file_required(move1, move2)
          end
        end

        context 'movement has not same figure type' do
          it 'return false' do
            move1 = Move.new(Figure.new(:pawn, :white), Coordinate.new(0, 0), Coordinate.new(1, 1))
            move2 = Move.new(Figure.new(:bishop, :white), Coordinate.new(0, 2), Coordinate.new(1, 1))
            expect(described_class)
              .not_to be_rank_file_required(move1, move2)
          end
        end
      end
    end
  end

  describe '#movement_rank_file' do
    context 'not required rank and file' do
      it 'return file false' do
        expect(described_class.movement_rank_file([], nil)[0]).to be_falsey
      end

      it 'return rank false' do
        expect(described_class.movement_rank_file([], nil)[1]).to be_falsey
      end
    end

    context 'rank_file_required? is true' do
      before do
        allow(described_class).to receive(:rank_file_required?).and_return(true)
      end

      context 'move.point_start.x == movement.point_start.x' do
        let(:move1) { Move.new(nil, Coordinate.new(0, 1), nil) }
        let(:move2) { Move.new(nil, Coordinate.new(0, 2), nil) }

        it 'return file false' do
          expect(described_class.movement_rank_file([move1], move2)[0]).to be_falsey
        end

        it 'return rank true' do
          expect(described_class.movement_rank_file([move1], move2)[1]).to be_truthy
        end
      end

      context 'move.point_start.x != movement.point_start.x' do
        let(:move1) { Move.new(nil, Coordinate.new(1, 1), nil) }
        let(:move2) { Move.new(nil, Coordinate.new(0, 2), nil) }

        it 'return file true' do
          expect(described_class.movement_rank_file([move1], move2)[0]).to be_truthy
        end

        it 'return rank false' do
          expect(described_class.movement_rank_file([move1], move2)[1]).to be_falsey
        end
      end
    end
  end

  describe '#algebraic_notation' do
    before do
      allow(described_class).to receive(:movement_rank_file).and_return([false, false])
    end

    context 'moves has 2: Move and PromotionMove' do
      let(:move) { Move.new(Figure.new(:pawn, :white), Coordinate.new(0, 0), Coordinate.new(0, 0)) }
      let(:promotion_move) do
        PromotionMove.new(Figure.new(:pawn, :white), Coordinate.new(0, 0),
                          Coordinate.new(0, 0), Figure.new(:queen, :white))
      end
      let(:moves) { [move, promotion_move] }

      it 'call Move.algebraic_notation once' do
        allow(move).to receive(:algebraic_notation)
        described_class.algebraic_notation(moves)
        expect(move).to have_received(:algebraic_notation).once
      end

      it 'call PromotionMove.algebraic_notation once' do
        allow(promotion_move).to receive(:algebraic_notation)
        described_class.algebraic_notation(moves)
        expect(promotion_move).to have_received(:algebraic_notation).once
      end

      it 'call movement_rank_file once' do
        described_class.algebraic_notation(moves)
        expect(described_class).to have_received(:movement_rank_file).once
      end

      it 'return Hash with length 2' do
        expect(described_class.algebraic_notation(moves).length).to be 2
      end
    end
  end
end
