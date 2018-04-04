require 'spec_helper'

RSpec.describe Spire::BasicData do
  describe 'create' do
    it 'returns a new instance of the calling class' do
      allow(Spire::BasicData.client).to receive(:post).and_return(JSON.generate(attributes_for(:item)))
      item = Spire::Item.create(attributes_for(:item, id: nil))
      expect(item.instance_of? Spire::Item).to eq true
    end
  end

  describe 'save' do
    it 'creates a new instance of the calling class and attemps to save it' do
      allow(Spire::BasicData.client).to receive(:post).and_return(JSON.generate(attributes_for(:item)))
      item = Spire::Item.save(attributes_for(:item, id: nil))
      expect(item.instance_of? Spire::Item).to eq true
    end
  end

  describe 'parse' do
    it 'generates an instance of the class that called it' do
      json = JSON.generate(attributes_for(:item))
      item = Spire::Item.parse(json)
      expect(item.instance_of? Spire::Item).to eq true
    end
  end

  describe 'parse_many' do
    it 'generates a list of instances based on the class that called it' do
      data = [
        attributes_for(:item),
        attributes_for(:item)
      ]
      json = JSON.generate({records: data})
      items = Spire::Item.parse_many(json)
      expect(items.class).to eq(Array)
      expect(items.length).to eq 2
      expect(items.first.instance_of? Spire::Item).to eq true
    end
  end

  describe 'register_attributes' do
    before :each do
      Spire::Item.register_attributes(:new_attribute)
    end

    it 'defines getters for the specified attributes' do
      item = Spire::Item.new({new_attribute: true})
      expect(item.new_attribute).to eq true
    end

    it 'defines setters for the specified attributes' do
      item = build(:item)
      item.new_attribute = true
      expect(item.new_attribute).to eq true
    end
  end

  describe 'update_fields' do
    it 'raises NotImplementedError' do
      expect{Spire::BasicData.new}.to raise_error(
        NotImplementedError
      ).with_message("Spire::BasicData does not implement update_fields.")
    end
  end

  describe 'refresh!' do
    it 'calls Spire::BasicData.find' do
      item = build(:item)
      allow(Spire::Item).to receive(:find)
      item.refresh!
      expect(Spire::Item).to have_received(:find).with(item.id)
    end
  end

  describe '==' do
    it 'returns true if both objects have the same id' do
      item = build(:item, id: 1)
      item2 = build(:item, id: 1)
      expect(item == item2).to eq true
    end

    it 'returns false if the objects have different ids' do
      item = build(:item, id: 1)
      item2 = build(:item, id: 2)
      expect(item == item2).to eq false
    end
  end

  describe 'client' do
    it 'returns an instance of client' do
      item = build(:item)
      expect(item.client.instance_of? Spire::Client).to eq(true)
    end
  end
end