require 'spec_helper'

RSpec.describe Spire::Item do
  let(:item) {build(:item)}

  describe 'find' do
    it 'calls client.find' do
      allow(Spire::BasicData.client).to receive(:find)
      Spire::Item.find(1)
      expect(Spire::BasicData.client).to have_received(:find).with('/inventory/items', 1, {})
    end
  end

  describe 'search' do
    it 'calls client.find_many with default limit of 10' do
      allow(Spire::BasicData.client).to receive(:find_many)
      Spire::Item.search("af-1")

      expect(Spire::BasicData.client).to have_received(
        :find_many
      ).with(Spire::Item, '/inventory/items/', {q: "af-1"})
    end

    it 'calls client.find_many with a custom limit' do
      allow(Spire::BasicData.client).to receive(:find_many)
      Spire::Item.search("af-1", 1000)

      expect(Spire::BasicData.client).to have_received(
        :find_many
      ).with(Spire::Item, '/inventory/items/', {q: "af-1", limit: 1000})
    end
  end

  describe 'filter' do
    it 'calls client.find_many' do
      allow(Spire::BasicData.client).to receive(:find_many)
      Spire::Item.filter('{"partNo":"ABCD-0001"}')

      expect(Spire::BasicData.client).to have_received(
        :find_many
      ).with(Spire::Item, '/inventory/items/', {filter: '{"partNo":"ABCD-0001"}'})
    end
  end

  describe 'create' do
    it 'calls client.create' do
      allow(Spire::BasicData.client).to receive(:create)
      Spire::Item.create(attributes_for(:item))
      expect(Spire::BasicData.client).to have_received(:create)
    end
  end

  describe 'valid?' do
    it 'returns true if part_no and description are present' do
      expect(item.valid?).to be true
    end

    it 'returns false if part_no is not present' do
      expect(build(:item, part_no: nil).valid?).to eq false
    end

    it 'returns false if description is not present' do
      expect(build(:item, description: nil).valid?).to eq false
    end
  end

  describe 'make_active' do
    it 'sets status to 0' do
      item.make_active
      expect(item.status).to eq 0
    end
  end

  describe 'make_inactive' do
    it 'sets status to 2' do
      item.make_inactive
      expect(item.status).to eq 2
    end
  end

  describe 'put_on_hold' do
    it 'sets status to 1' do
      item.put_on_hold
      expect(item.status).to eq 1
    end
  end

  describe 'delete' do
    it 'calls client.delete' do
      allow(item.client).to receive(:delete)
      item.delete
      expect(item.client).to have_received(:delete).with("/inventory/items/#{item.id}")
    end
  end

  describe 'update!' do
    it 'calls client.put' do
      item = Spire::Item.new(attributes_for(:item))
      allow(item.client).to receive(:put)
      item.update!
      expect(item.client).to have_received(:put)
    end
  end

  describe 'save' do
    before :each do
      allow(Spire::BasicData.client).to receive(:post)
      allow_any_instance_of(Spire::Item).to receive(:from_response)
    end

    it 'calls client.save' do
      item.id = nil
      item.save
      expect(Spire::BasicData.client).to have_received(:post)
    end

    it 'calls from_response' do
      item.id = nil
      item.save
      expect(item).to have_received(:from_response)
    end

    it 'calls update! if id is present' do
      allow(item).to receive(:update!)
      item.save
      expect(item).to have_received(:update!)
    end
  end
end