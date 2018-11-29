require 'spec_helper'

RSpec.describe Spire::Upc do
  let(:upc) {build(:upc)}

  describe 'find' do
    it 'calls client.find' do
      allow(Spire::BasicData.client).to receive(:find)
      Spire::Upc.find(1)
      expect(Spire::BasicData.client).to have_received(:find).with('/inventory/upcs', 1, {})
    end
  end

  describe 'search' do
    it 'calls client.find_many' do
      allow(Spire::BasicData.client).to receive(:find_many)
      Spire::Upc.search("af-1")

      expect(Spire::BasicData.client).to have_received(
        :find_many
      ).with(Spire::Upc, '/inventory/upcs/', {q: "af-1"})
    end
  end

  describe 'create' do
    it 'calls client.create' do
      allow(Spire::BasicData.client).to receive(:create)
      Spire::Upc.create(attributes_for(:upc))
      expect(Spire::BasicData.client).to have_received(:create)
    end
  end

  describe 'valid?' do
    it 'returns true if upc, uom_code, and inventory are present' do
      expect(upc.valid?).to be true
    end

    it 'returns false if uom_code is not present' do
      expect(build(:upc, uom_code: nil).valid?).to eq false
    end

    it 'returns false if upc is not present' do
      expect(build(:upc, upc: nil).valid?).to eq false
    end

    it 'returns false if inventory is not present' do
      expect(build(:upc, inventory: nil).valid?).to eq false
    end
  end

  describe 'delete' do
    it 'calls client.delete' do
      allow(upc.client).to receive(:delete)
      upc.delete
      expect(upc.client).to have_received(:delete).with("/inventory/upcs/#{upc.id}")
    end
  end

  describe 'update!' do
    it 'calls client.put' do
      upc = Spire::Upc.new(attributes_for(:upc, id: 1))

      allow(upc.client).to receive(:put)
      upc.update!
      expect(upc.client).to have_received(:put)
    end
  end

  describe 'save' do
    before :each do
      allow(Spire::BasicData.client).to receive(:post)
      allow_any_instance_of(Spire::Upc).to receive(:from_response)
    end

    it 'calls client.save' do
      upc.save
      expect(Spire::BasicData.client).to have_received(:post)
    end

    it 'calls from_response' do
      upc.save
      expect(upc).to have_received(:from_response)
    end

    it 'calls update! if id is present' do
      upc = Spire::Upc.new(attributes_for(:upc, id: 1))
      allow(upc).to receive(:update!)
      upc.save
      expect(upc).to have_received(:update!)
    end
  end
end