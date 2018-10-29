require 'spec_helper'

RSpec.describe Spire::Order do
  let(:order) {build(:order)}

  describe 'find' do
    it 'calls client.find' do
      allow(Spire::BasicData.client).to receive(:find)
      Spire::Order.find(1)
      expect(Spire::BasicData.client).to have_received(:find).with('/sales/orders', 1)
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
      # allow(order.client).to receive(:delete)
      build(:order)
      # puts order
      # order.delete
      # expect(order.client).to have_received(:delete).with("/sales/orders/#{order.id}")
    end
  end
  
end