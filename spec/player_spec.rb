require './lib/chess'

describe Player do
  describe '#to_s' do
    context 'when name:Bob and color:white' do
      it 'returns Bob(white)' do
        expect(described_class.new('Bob', :white).to_s).to eql('Bob(white)')
      end
    end
  end
end
