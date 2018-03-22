require 'spire'

describe Spire::Item do
  describe 'all' do
    it "all returns all Spire inventory items" do
      expect(Spire::Item.all).to eq()
    end
  end

  describe 'find' do
    it 'returns the item matching the specified the id' do
      expect(Spire::Item.find(1)).to eq()
    end
  end

  describe 'find_by_query' do
    it 'returns items matching the specified query' do

    end
  end
end