require 'spec_helper'

RSpec.describe Spire::Vendor do
  let(:vendor) {build(:vendor)}

  describe 'find' do
    it 'calls client.find' do
      allow(Spire::BasicData.client).to receive(:find)
      Spire::Vendor.find(1)
      expect(Spire::BasicData.client).to have_received(:find).with('/vendors', 1, {})
    end
  end

  describe 'search' do
    it 'calls client.find_many' do
      allow(Spire::BasicData.client).to receive(:find_many)
      Spire::Vendor.search("af-1")

      expect(Spire::BasicData.client).to have_received(
        :find_many
      ).with(Spire::Vendor, '/vendors/', {q: "af-1"})
    end
  end

  describe 'create' do
    it 'calls client.create' do
      allow(Spire::BasicData.client).to receive(:create)
      Spire::Vendor.create(attributes_for(:vendor))
      expect(Spire::BasicData.client).to have_received(:create)
    end
  end

  describe 'valid?' do
    it 'returns true if vendor_no and name are present' do
      expect(vendor.valid?).to be true
    end

    it 'returns false if vendor_no is not present' do
      expect(build(:vendor, vendor_no: nil).valid?).to eq false
    end

    it 'returns false if name is not present' do
      expect(build(:vendor, name: nil).valid?).to eq false
    end
  end

  describe 'make_active' do
    it 'sets status to "A"' do
      vendor.make_active
      expect(vendor.status).to eq 'A'
    end
  end

  describe 'make_inactive' do
    it 'sets status to "I"' do
      vendor.make_inactive
      expect(vendor.status).to eq "I"
    end
  end

  describe 'delete' do
    it 'calls client.delete' do
      allow(vendor.client).to receive(:delete)
      vendor.delete
      expect(vendor.client).to have_received(:delete).with("/vendors/#{vendor.id}")
    end
  end

  describe 'update!' do
    it 'calls client.put' do
      vendor = Spire::Vendor.new(attributes_for(:vendor))
      allow(vendor.client).to receive(:put)
      vendor.update!
      expect(vendor.client).to have_received(:put)
    end
  end

  describe 'save' do
    before :each do
      allow(Spire::BasicData.client).to receive(:post)
      allow_any_instance_of(Spire::Vendor).to receive(:from_response)
    end

    it 'calls client.save' do
      vendor.id = nil
      vendor.save
      expect(Spire::BasicData.client).to have_received(:post)
    end

    it 'calls from_response' do
      vendor.id = nil
      vendor.save
      expect(vendor).to have_received(:from_response)
    end

    it 'calls update! if id is present' do
      allow(vendor).to receive(:update!)
      vendor.save
      expect(vendor).to have_received(:update!)
    end
  end
end