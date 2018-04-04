require 'spec_helper'

RSpec.describe Spire::Client do
  let(:configuration) {build(:configuration)}
  let(:client) {Spire.client}

  before(:each) do
    Spire.configure do |config|
      config.company = configuration.company
      config.username = configuration.username
      config.password = configuration.password
      config.host = configuration.host
      config.port = configuration.port
    end
  end

  after :each do
    Spire.reset!
  end

  describe 'HTTP methods' do
    before :each do
      allow(Spire::SInternet).to receive(:execute).and_return(
        Spire::Response.new(200, {}, "{}")
      )
    end

    describe 'get' do
      before :each do

      end

      it 'returns a response body' do
        expect(client.get('/inventory/items/1')).to eq "{}"
      end

      it 'builds a properly formatted request' do
        path = "/inventory/items/1"
        uri = URI("https://#{configuration.host}:#{configuration.port}/api/v#{Spire::API_VERSION}/companies/#{configuration.company}#{path}")

        request = Spire::Request.new :get, uri, {"Content-Type"=>"application/json"}, nil, configuration.username, configuration.password

        client.get(path)
        expect(Spire::SInternet).to have_received(:execute).with(request)
      end

      it 'appends params to the uri if params is present' do
        path = "/inventory/items/1"
        uri = URI("https://#{configuration.host}:#{configuration.port}/api/v#{Spire::API_VERSION}/companies/#{configuration.company}#{path}?q=af-1")

        request = Spire::Request.new :get, uri, {"Content-Type"=>"application/json"}, nil, configuration.username, configuration.password

        client.get(path, {q: 'af-1'})
        expect(Spire::SInternet).to have_received(:execute).with(request)
      end
    end

    describe 'post' do
      it 'returns a response body' do
        expect(client.post('/inventory/items/')).to eq "{}"
      end

      it 'creates a request with the specified body' do
        body = {body: true}
        path = "/inventory/items/"
        client.post(path, body)
        uri = URI("https://#{configuration.host}:#{configuration.port}/api/v#{Spire::API_VERSION}/companies/#{configuration.company}#{path}")

        request = Spire::Request.new :post, uri, {"Content-Type"=>"application/json"}, body, configuration.username, configuration.password
        expect(Spire::SInternet).to have_received(:execute).with(request)
      end
    end

    describe 'put' do
      it 'returns a response body' do
        expect(client.put('/inventory/items/1')).to eq "{}"
      end

      it 'creates a request with the specified body' do
        body = {body: true}
        path = "/inventory/items/1"
        client.put(path, body)
        uri = URI("https://#{configuration.host}:#{configuration.port}/api/v#{Spire::API_VERSION}/companies/#{configuration.company}#{path}")

        request = Spire::Request.new :put, uri, {"Content-Type"=>"application/json"}, body, configuration.username, configuration.password
        expect(Spire::SInternet).to have_received(:execute).with(request)
      end
    end

    describe 'delete' do
      before :each do
        allow(Spire.logger).to receive(:error)
      end

      it 'returns a response body' do
        expect(client.delete('/inventory/items/1')).to eq "{}"
      end

      it 'raises an error and calls logger.error if http status is something other than 200 or 201' do
        allow(Spire::SInternet).to receive(:execute).and_return(
          Spire::Response.new(422, {}, "{}")
        )

        expect{client.delete('/inventory/items/1')}.to raise_error
        expect(Spire.logger).to have_received(:error)
      end

      it "returns '' if response is nil" do
        allow(Spire::SInternet).to receive(:execute).and_return(nil)
        expect(client.delete('/inventory/items/1')).to eq ''
      end
    end
  end


  describe 'find' do
    it 'returns an instance of class specified by path' do
      allow(client).to receive(:get).and_return(
        JSON.generate(attributes_for(:item, id: 1))
      )

      item = client.find('/inventory/items', 1)
      expect(item.instance_of? Spire::Item).to eq true
      expect(item.id).to eq 1
    end
  end

  describe 'find_many' do
    it 'returns an array of instances of the passed class' do
      json = JSON.generate({
        records: [
          attributes_for(:item, id: 1),
          attributes_for(:item, id: 2)
        ]
      })

      allow(client).to receive(:get).and_return(json)
      items = client.find_many(Spire::Item, '/inventory/items')
      expect(items.instance_of? Array).to eq true
      expect(items.length).to eq 2
      expect(items.first.instance_of? Spire::Item).to eq true
      expect(items.first.id).to eq 1
    end
  end

  describe 'create' do
    it 'creates a new instance of the specified class and attemps to save it' do
      options = attributes_for(:vendor)

      allow(Spire::BasicData.client).to receive(:post).and_return(JSON.generate(attributes_for(:vendor)))

      vendor = client.create(:vendor,
        'vendorNo' => options[:vendor_no],
        'code' => options[:code],
        'name' => options[:name],
        'hold' => options[:hold],
        'status' => options[:status],
        'address' => options[:address],
        'shippingAddresses' => options[:shipping_addresses],
        'paymentTerms' => options[:payment_terms],
        'currency' => options[:currency],
        'foregroundColor' => options[:foreground_color],
        'backgroundColor' => options[:background_color],
        'createdBy' => options[:created_by],
        'modifiedBy' => options[:modified_by],
        'created' => options[:created],
        'modified' => options[:modified],
        'createdDateTime' => options[:created_date_time],
        'modifiedDateTime' => options[:modified_date_time]
      )
      expect(vendor.instance_of? Spire::Vendor).to eq true
    end
  end

  describe 'configuration' do
    it 'returns a new configuration instance if one doesn\'t exist' do
      Spire.reset!
      configuration = client.configuration
      expect(configuration.instance_of? Spire::Configuration).to eq true
      expect(configuration.username).to eq nil
    end

    it 'returns an existing configuration if one exists' do
      Spire.configure do |config|
        config.host = 'BiteSite'
      end

      expect(client.configuration.host).to eq 'BiteSite'
    end
  end

  describe 'auth_policy' do
    it 'returns an instance of AuthPolicy if username and password are not present' do
      configuration = build(:configuration)

      Spire.configure do |config|
        config.company = configuration.company
        config.host = configuration.host
        config.port = configuration.port
      end

      expect(client.auth_policy.instance_of? Spire::Authorization::AuthPolicy).to eq true
    end

    it 'returns an instance of BasicAuthPolicy if username and password are present' do
      expect(client.auth_policy.instance_of? Spire::Authorization::BasicAuthPolicy).to eq true
    end
  end
end