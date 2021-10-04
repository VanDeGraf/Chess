require './lib/board'

describe RepetitionLog do
  subject(:log) { described_class.new }

  describe '#n_fold_repetition?' do
    context 'required repetition count is 3' do
      let(:repetition_count) { 3 }

      context 'storage empty' do
        it 'return false' do
          expect(log).not_to be_n_fold_repetition(repetition_count)
        end
      end

      context 'storage has 1 hash with 2 count' do
        it 'return false' do
          log.instance_variable_set(:@repetition_hash, { 'hash1' => 2 })
          expect(log).not_to be_n_fold_repetition(repetition_count)
        end
      end

      context 'storage has 1 hash with 3 count' do
        it 'return true' do
          log.instance_variable_set(:@repetition_hash, { 'hash1' => 3 })
          expect(log).to be_n_fold_repetition(repetition_count)
        end
      end

      context 'storage has 1 hash with 4 count' do
        it 'return true' do
          log.instance_variable_set(:@repetition_hash, { 'hash1' => 4 })
          expect(log).to be_n_fold_repetition(repetition_count)
        end
      end

      context 'storage has 2 hash with 2 count' do
        it 'return false' do
          log.instance_variable_set(:@repetition_hash, { 'hash1' => 2, 'hash2' => 2 })
          expect(log).not_to be_n_fold_repetition(repetition_count)
        end
      end

      context 'storage has 2 hash with 1 and 3 counts' do
        it 'return true' do
          log.instance_variable_set(:@repetition_hash, { 'hash1' => 1, 'hash2' => 3 })
          expect(log).to be_n_fold_repetition(repetition_count)
        end
      end
    end
  end

  describe '#add!' do
    before do
      allow(log).to receive(:repetition_hash_summary).and_return('hash')
    end

    context 'movement is nil' do
      it 'dont call repetition_hash_summary' do
        log.add!(nil, nil)
        expect(log).not_to have_received(:repetition_hash_summary)
      end
    end

    context 'storage already has this hash with count 1' do
      let(:move) { Move.new(Figure.new(:pawn, :white), nil, nil) }

      it 'call repetition_hash_summary once' do
        log.add!(move, nil)
        expect(log).to have_received(:repetition_hash_summary).once
      end

      it 'add 1 to exists hash' do
        log.instance_variable_set(:@repetition_hash, { 'hash' => 1 })
        expect { log.add!(move, nil) }.to change { log.instance_variable_get(:@repetition_hash)['hash'] }.to(2)
      end
    end

    context 'storage is empty' do
      let(:move) { Move.new(Figure.new(:pawn, :white), nil, nil) }

      it 'call repetition_hash_summary once' do
        log.add!(move, nil)
        expect(log).to have_received(:repetition_hash_summary).once
      end

      it 'create new hash with count 1' do
        expect { log.add!(move, nil) }.to change { log.instance_variable_get(:@repetition_hash)['hash'] }.to(1)
      end
    end
  end
end
