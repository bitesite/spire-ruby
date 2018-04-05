require 'spec_helper'

RSpec.describe Spire::SInternet do
  describe 'execute' do
    let(:uri) {URI("https://www.example.com/api/v1/companies/")}
    let(:request) {Spire::Request.new :get, uri, {"Content-Type"=>"application/json"}, "{}"}
    let(:response) {Spire::Response.new(200, {location: "https://www.example.com/api/v1/companies/bitesite/inventory/items/1"}, "{}")}

    before :each do
      allow(RestClient::Request).to receive(:execute).and_return(response)
    end

    it 'returns nil if request is not present' do
      expect(Spire::SInternet.execute(nil)).to eq nil
    end

    it 'calls RestClient::Request.execute' do
      Spire::SInternet.execute(request)
      expect(RestClient::Request).to have_received(:execute)
    end

    it 'returns a new Spire::Response instance' do
      expect(Spire::SInternet.execute(request).instance_of? Spire::Response).to eq true
    end

    it 'returns the id of the new resource instance as json if request method is post' do
      request.verb = :post
      expect(Spire::SInternet.execute(request).body).to eq "{\"id\":\"1\"}"
    end

    it 'creates a new response with the http code of the response if RestClient raises an exception' do
      exception = RestClient::Exception.new(nil, 500)
      allow(RestClient::Request).to receive(:execute).and_raise(exception)
      expect(Spire::SInternet.execute(request).code).to eq 500
    end
  end
end