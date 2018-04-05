require 'spec_helper'

RSpec.describe Spire::JsonUtils do
  describe 'instance from_response' do
    it 'updates self with the passed data ' do
      item = build(:item, description: nil)

      description = "This is a description"
      item.from_response("{\"description\": \"#{description}\"}")
      expect(item.description).to eq description
    end
  end

  describe 'instance parse_json' do
    let(:json) {JSON.generate(attributes_for(:item))}

    it 'returns a hash of the specified json' do
      expect(build(:item).parse_json(json).instance_of? Hash).to eq true
    end

    it 'raises an exception if JSON.parse raises an exception' do
      allow(JSON).to receive(:parse).and_raise(JSON::ParserError)
      expect{build(:item).parse_json(json)}.to raise_error
    end

    it 'calls Spire.logger.error if JSON.parse raises an exception' do
      allow(JSON).to receive(:parse).and_raise(JSON::ParserError)
      allow(Spire.logger).to receive(:error)
      expect{build(:item).parse_json(json)}.to raise_error
      expect(Spire.logger).to have_received(:error).with('Unknown error.')
    end
  end

  describe 'from_response' do
    it 'returns a new instance of the calling class given some json' do
      json = JSON.generate(attributes_for(:item))

      expect(
        Spire::Item.from_response(json).instance_of? Spire::Item
      ).to eq true
    end
  end

  describe 'from_json' do
    it 'returns a new instance of the calling class when it\'s passed a hash' do
      item = Spire::Item.from_json(attributes_for(:item, id: 1))
      expect(item.instance_of? Spire::Item).to eq true
    end

    it 'returns an array of new instances of the calling class when it\'s passed an array' do
      array = [
        attributes_for(:item, id: 1),
        attributes_for(:item, id: 2)
      ]
      items = Spire::Item.from_json(array)
      expect(items.instance_of? Array).to eq true
      expect(items.length).to eq 2
      expect(items.first.instance_of? Spire::Item).to eq true
    end

    it 'returns the passed data if it is not of type array nor hash ' do
      json = Spire::Item.from_json("{}")
      expect(json.instance_of? String).to eq true
    end
  end

  describe 'parse_json' do
    it 'parses the specified json' do
      attributes = {
        "id"=>1,
        "description"=>"This is a description"
      }

      expect(
        Spire::BasicData.parse_json(
          JSON.generate(attributes)
        )
      ).to eq attributes
    end
  end
end