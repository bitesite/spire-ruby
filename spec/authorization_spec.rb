require 'spec_helper'

RSpec.describe Spire::Authorization do
  let(:uri) {URI("https://www.example.com/api/v1/companies/")}

  describe 'AuthPolicy' do
    describe 'authorize' do
      it 'raises a spire configuration error' do
        expect{
          Spire::Authorization::AuthPolicy.new.authorize
        }.to raise_error(
          Spire::ConfigurationError
        ).with_message("Spire has not been configured to make authorized requests.")
      end
    end
  end

  describe 'BasicAuthPolicy' do
    describe 'new' do
      it 'creates a new BasicAuthPolicy instance with the specified attrs' do
        attributes = attributes_for(:basic_auth_policy)
        basic_auth = Spire::Authorization::BasicAuthPolicy.new(attributes)
        expect(basic_auth.username).to eq(attributes[:username])
      end
    end

    describe 'instance authorize' do
      it 'creates and authorizes a new request' do
        request = Spire::Request.new :get, uri, {"Content-Type"=>"application/json"}, "{}"
        basic_auth = build(:basic_auth_policy)
        authorized_request = basic_auth.authorize(request)
        expect(authorized_request.user).to eq(basic_auth.username)
        expect(authorized_request.password).to eq(basic_auth.password)
      end
    end

    describe 'self.authorize' do
      it 'creates a new unauthorized request' do
        request = Spire::Request.new :get, uri, {"Content-Type"=>"application/json"}, "{}"
        unauthorized_request = Spire::Authorization::BasicAuthPolicy.authorize(request)
        expect(unauthorized_request.user).to eq nil
        expect(unauthorized_request.password).to eq nil
      end
    end
  end
end