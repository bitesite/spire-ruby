require 'json'
require 'logger'
require 'active_model'
require 'active_support'

# Spire a Ruby wrapper around the Spire Systems API
#
# First, you will need to setup your account information.
#
# Spire.configure do |config|
#   config.company = SPIRE_COMPANY
#   config.username = SPIRE_USERNAME
#   config.password = SPIRE_PASSWORD
#   config.host = SPIRE_HOST # Example: www.example.com
#   config.port = SPIRE_PORT # Default is 10880
# end
#
# All the calls this library makes to the Spire API require authentication. Be sure to protect your account credentials.

module Spire
  autoload :Error,          'spire/error'
  autoload :Configuration,  'spire/configuration'
  autoload :Client,         'spire/client'
  autoload :Item,           'spire/item'
  autoload :Customer,       'spire/customer'
  autoload :Vendor,         'spire/vendor'
  autoload :Request,        'spire/net'
  autoload :SInternet,      'spire/net'
  autoload :BasicData,      'spire/basic_data'
  autoload :JsonUtils,      'spire/json_utils'

  module Authorization
    autoload :AuthPolicy,      'spire/authorization'
    autoload :BasicAuthPolicy, 'spire/authorization'
  end

  API_VERSION = 1

  # This error is thrown when your client has not been configured
  ConfigurationError = Class.new(Error)

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.client
    @client ||= Client.new
  end

  def self.configure(&block)
    reset!
    client.configure(&block)
  end

  def self.reset!
    @client = nil
  end

  def self.auth_policy; client.auth_policy; end
  def self.configuration; client.configuration; end
end
