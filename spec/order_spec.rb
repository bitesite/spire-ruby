require 'spec_helper'

RSpec.describe Spire::Order do
  let(:order) {build(:order)}

  describe 'find' do
    it 'calls client.find' do
      allow(Spire::BasicData.client).to receive(:find)
      Spire::Order.find(1)
      expect(Spire::BasicData.client).to have_received(:find).with('/sales/orders', 1, {})
    end
  end

  describe 'search' do
    it 'calls client.find_many' do
      allow(Spire::BasicData.client).to receive(:find_many)
      Spire::Order.search("sample@emailaddress.com")

      expect(Spire::BasicData.client).to have_received(
        :find_many
      ).with(Spire::Order, '/sales/orders/', {q: "sample@emailaddress.com"})
    end
  end

  describe 'create' do
    it 'calls client.create' do 
      allow(Spire::BasicData.client).to receive(:create)
      Spire::Order.create(attributes_for(:order))
      expect(Spire::BasicData.client).to have_received(:create)
    end
  end

  describe 'delete' do
    it 'calls client.delete' do
      allow(order.client).to receive(:delete)
      order.delete
      expect(order.client).to have_received(:delete).with("/sales/orders/#{order.id}")
    end
  end

  describe 'valid?' do
    before (:each) do 
      #assume order_no is not nil
      order = build(:order)
    end

    it 'returns true if items, customer are present' do
      expect(order.valid?).to be true
    end

    it 'returns false if items is not present' do
      expect(build(:order, items: nil).valid?).to eq false
    end

    it 'returns false if customer is not present' do
      expect(build(:order, customer: nil).valid?).to eq false
    end
  end

  describe 'make_active' do
    it 'sets status to 0' do
      order.make_active
      expect(order.status).to eq "0"
    end
  end

  describe 'make_inactive' do
    it 'sets status to 2' do
      order.make_inactive
      expect(order.status).to eq "2"
    end
  end

  describe 'put_on_hold' do
    it 'sets status to 1' do
      order.put_on_hold
      expect(order.status).to eq "1"
    end
  end

  describe 'delete' do
    it 'calls client.delete' do
      allow(order.client).to receive(:delete)
      order.delete
      expect(order.client).to have_received(:delete).with("/sales/orders/#{order.id}")
    end
  end

  describe 'update!' do
    it 'calls client.put' do
      order = Spire::Order.new(attributes_for(:order))
      allow(order.client).to receive(:put)
      order.update!
      expect(order.client).to have_received(:put)
    end
  end

  describe 'save' do
    before :each do
      allow(Spire::BasicData.client).to receive(:post)
      allow_any_instance_of(Spire::Order).to receive(:from_response)
    end

    it 'calls client.save' do
      order.id = nil
      order.save
      expect(Spire::BasicData.client).to have_received(:post)
    end

    it 'calls from_response' do
      order.id = nil
      order.save
      expect(order).to have_received(:from_response)
    end

    it 'calls update! if id is present' do
      allow(order).to receive(:update!)
      order.save
      expect(order).to have_received(:update!)
    end
  end
end
