require './lib/board'

describe Promotion do
  subject(:promotion) { described_class.new(figure1, point_start, point_end, figure2) }

  let(:figure1) { Figure.new(:bishop, :white) }
  let(:figure2) { Figure.new(:queen, :white) }
  let(:point_start) { Coordinate.new(0, 0) }
  let(:point_end) { Coordinate.new(2, 1) }

  describe '#special?' do
    it 'is' do
      expect(promotion).to be_special
    end
  end

  describe '#perform_movement' do
    subject(:promotion) do
      described_class.new(Figure.new(:pawn, :white),
                          point_start, point_end, promoted_to)
    end

    let(:promoted_to) { Figure.new(:queen, :white) }
    let(:point_start) { Coordinate.new(0, 0) }
    let(:point_end) { Coordinate.new(1, 0) }

    let(:board) { Board.new }

    before do
      allow(board).to receive(:remove_at!)
      allow(board).to receive(:replace_at!)
    end

    it 'remove old figure from old position' do
      promotion.perform_movement(board)
      expect(board).to have_received(:remove_at!).with(point_start)
    end

    it 'set new figure on new position' do
      promotion.perform_movement(board)
      expect(board).to have_received(:replace_at!).with(point_end, promoted_to)
    end
  end

  describe '#on_promotion_path?' do
    def move_instance(color, coordinate_y)
      Capture.new(
        Figure.new(:pawn, color),
        Coordinate.new(0, 2),
        Coordinate.new(0, coordinate_y),
        Figure.new(:pawn, color)
      )
    end

    context 'figure color is white' do
      let(:color) { :white }

      context 'point end y coordinate at 0' do
        it 'return false' do
          expect(described_class).not_to be_on_promotion_path(move_instance(color, 0))
        end
      end

      context 'point end y coordinate at 1' do
        it 'return false' do
          expect(described_class).not_to be_on_promotion_path(move_instance(color, 1))
        end
      end

      context 'point end y coordinate at 6' do
        it 'return false' do
          expect(described_class).not_to be_on_promotion_path(move_instance(color, 6))
        end
      end

      context 'point end y coordinate at 7' do
        it 'return true' do
          expect(described_class).to be_on_promotion_path(move_instance(color, 7))
        end
      end
    end

    context 'figure color is black' do
      let(:color) { :black }

      context 'point end y coordinate at 0' do
        it 'return true' do
          expect(described_class).to be_on_promotion_path(move_instance(color, 0))
        end
      end

      context 'point end y coordinate at 1' do
        it 'return false' do
          expect(described_class).not_to be_on_promotion_path(move_instance(color, 1))
        end
      end

      context 'point end y coordinate at 6' do
        it 'return false' do
          expect(described_class).not_to be_on_promotion_path(move_instance(color, 6))
        end
      end

      context 'point end y coordinate at 7' do
        it 'return false' do
          expect(described_class).not_to be_on_promotion_path(move_instance(color, 7))
        end
      end
    end
  end

  describe '#from_movement_by_figure' do
    let(:move) do
      Move.new(Figure.new(:pawn, :white),
               Coordinate.new(0, 6),
               Coordinate.new(0, 7))
    end
    let(:capture) do
      Capture.new(Figure.new(:pawn, :white),
                  Coordinate.new(0, 6),
                  Coordinate.new(0, 7),
                  Figure.new(:bishop, :black))
    end
    let(:promotion_figure_type) { :queen }

    it 'return instance with same start figure' do
      expect(described_class.from_movement_by_figure(capture, promotion_figure_type).figure)
        .to be_equal(capture.figure)
    end

    it 'return instances with same point_start' do
      expect(described_class.from_movement_by_figure(capture, promotion_figure_type).point_start)
        .to be_equal(capture.point_start)
    end

    it 'return instances with same point_end' do
      expect(described_class.from_movement_by_figure(capture, promotion_figure_type).point_end)
        .to be_equal(capture.point_end)
    end

    it 'return instances with same color of new figure' do
      expect(described_class.from_movement_by_figure(capture, promotion_figure_type).promoted_to.color)
        .to be_equal(capture.figure.color)
    end

    context 'move is Move class' do
      it 'return PromotionMove instance' do
        expect(described_class.from_movement_by_figure(move, promotion_figure_type))
          .to be_a(PromotionMove)
      end
    end

    context 'move is Capture class' do
      it 'return PromotionCapture instance' do
        expect(described_class.from_movement_by_figure(capture, promotion_figure_type))
          .to be_a(PromotionCapture)
      end

      it 'return instance with same captured figure' do
        expect(described_class.from_movement_by_figure(capture, promotion_figure_type).captured)
          .to be_equal(capture.captured)
      end
    end
  end

  describe '#from_movement' do
    before do
      allow(described_class).to receive(:on_promotion_path?).and_return(true)
      allow(described_class).to receive(:from_movement_by_figure)
    end

    context 'move is Move class' do
      let(:move) do
        Move.new(Figure.new(:pawn, :white),
                 Coordinate.new(0, 6),
                 Coordinate.new(0, 7))
      end

      it 'check path' do
        described_class.from_movement(move)
        expect(described_class).to have_received(:on_promotion_path?)
      end

      it 'call from_movement 4 times' do
        described_class.from_movement(move)
        expect(described_class).to have_received(:from_movement_by_figure).exactly(4).times
      end
    end

    context 'move is Capture class' do
      let(:capture) do
        Capture.new(Figure.new(:pawn, :white),
                    Coordinate.new(0, 6),
                    Coordinate.new(0, 7),
                    Figure.new(:bishop, :black))
      end

      it 'check path' do
        described_class.from_movement(capture)
        expect(described_class).to have_received(:on_promotion_path?)
      end

      it 'call from_movement 4 times' do
        described_class.from_movement(capture)
        expect(described_class).to have_received(:from_movement_by_figure).exactly(4).times
      end
    end
  end
end
