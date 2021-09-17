require './lib/chess'

describe Player do
  describe '#to_s' do
    context 'when name:Bob and color:white' do
      it 'should return Bob(white)' do
        expect(Player.new('Bob', :white).to_s).to eql('Bob(white)')
      end
    end
  end
end
