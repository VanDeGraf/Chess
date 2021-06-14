require './lib/chess'

describe Player do
  describe '.name_input_parse' do
    context 'when input is valid' do
      before do
        allow(Player).to receive(:gets).and_return("Bob\n")
      end
      it 'should return hash' do
        expect(Player.name_input_parse).to be_a(Hash)
      end
      it 'should contain action key' do
        expect(Player.name_input_parse.key?(:action)).to be_truthy
      end
      it 'should be action == :name' do
        expect(Player.name_input_parse[:action]).to eql(:name)
      end
      it 'should contain name key with inputted name' do
        expect(Player.name_input_parse[:name]).to eql('Bob')
      end
    end
    context 'when input contain special chars' do
      before do
        allow(Player).to receive(:gets).and_return("Bob&^%&^$\n")
      end
      it 'should return error action' do
        expect(Player.name_input_parse[:action]).to eql(:error)
      end
      it 'should contain error message option' do
        expect(Player.name_input_parse.key?(:msg)).to be_truthy
      end
    end
    context 'when input contain less than 3 alphabet chars' do
      before do
        allow(Player).to receive(:gets).and_return(". A'\n")
      end
      it 'should return error action' do
        expect(Player.name_input_parse[:action]).to eql(:error)
      end
    end
  end

  describe '#turn_input_parse' do
    subject(:player) { Player.new('Bob', :white) }
    context 'when input is invalid' do
      before do
        allow(player).to receive(:gets).and_return("Bob\n")
      end
      it 'should return Hash' do
        expect(player.turn_input_parse).to be_a(Hash)
      end
      it 'should contain action key' do
        expect(player.turn_input_parse.key?(:action)).to be_truthy
      end
      it 'should return action == :error' do
        expect(player.turn_input_parse[:action]).to eql(:error)
      end
      it 'should return error msg' do
        expect(player.turn_input_parse.key?(:msg)).to be_truthy
      end
    end
    context 'when input is valid' do
      context 'when input is move coordinates' do
        it 'should return action == :move' do
          allow(player).to receive(:gets).and_return("a1 a2\n")
          expect(player.turn_input_parse[:action]).to eql(:move)
        end
      end
      context 'when input is special move menu number' do
        it 'should return action == :special_move' do
          allow(player).to receive(:gets).and_return("s 1\n")
          expect(player.turn_input_parse[:action]).to eql(:special_move)
        end
      end
      context 'when input is command' do
        it 'should return action == :command' do
          allow(player).to receive(:gets).and_return("/load name\n")
          expect(player.turn_input_parse[:action]).to eql(:command)
        end
      end
    end
  end
  describe '#to_s' do
    context 'when name:Bob and color:white' do
      it 'should return Bob(white)' do
        expect(Player.new('Bob', :white).to_s).to eql('Bob(white)')
      end
    end
  end
end
