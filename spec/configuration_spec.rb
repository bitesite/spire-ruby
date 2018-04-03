require 'spec_helper'

RSpec.describe Spire::Configuration do
  let(:configuration) {build(:configuration)}

  describe 'configurable_attributes' do
    it 'returns Spire::Configuration::CONFIGURABLE_ATTRIBUTES' do
      expect(Spire::Configuration.configurable_attributes).to eq Spire::Configuration::CONFIGURABLE_ATTRIBUTES
    end
  end

  describe 'initialize' do
    it 'creates a new configuration instance and assigns attributes' do
      attributes = attributes_for(:configuration)
      configuration = Spire::Configuration.new(attributes)
      expect(configuration.company).to eq attributes[:company]
    end

    it 'sets a default port of 10880 if port is not present' do
      new_configuration = Spire::Configuration.new(attributes_for(:configuration, port: nil))
      expect(new_configuration.port).to eq(10880)
    end
  end

  describe 'attributes=' do
    it 'assigns instance variables for configuration' do
      configuration = build(:configuration)
      old_company = configuration.company
      company = 'BiteSite'
      configuration.attributes = attributes_for(:configuration, company: company)
      expect(configuration.company).to eq company
    end
  end

  describe 'credentials' do
    it 'returns username and password if basic credentials are present' do
      configuration = build(:configuration)

      credentials = {
        username: configuration.username,
        password: configuration.password
      }

      expect(configuration.credentials).to eq credentials
    end

    it 'returns {} if basic credentials are not present' do
      configuration = build(:configuration, username: nil, password: nil)
      expect(configuration.credentials).to eq({})
    end
  end

  describe 'basic?' do
    it 'returns true if username and password are present' do
      expect(configuration.basic?).to eq true
    end

    it 'returns false if username and password are not present' do
      configuration = build(:configuration, username: nil, password: nil)
      expect(configuration.basic?).to eq false
    end
  end
end