require 'securerandom'

module Spire
  module Authorization

    AuthPolicy = Class.new do
      def initialize(attrs = {}); end

      def authorize(*args)
        raise Spire::ConfigurationError, "Spire has not been configured to make authorized requests."
      end
    end

    class BasicAuthPolicy
      class << self
        attr_accessor :username, :password

        def authorize(request)
          new.authorize(request)
        end
      end

      attr_accessor :username, :password

      def initialize(attrs = {})
        @username = attrs[:username] || self.class.username
        @password = attrs[:password] || self.class.password
      end

      def authorize(request)
        request.user = @username
        request.password = @password
        Request.new request.verb, request.uri, request.headers, request.body, request.user, request.password
      end
    end

    class Clock
      def self.timestamp; Time.now.to_i; end
    end

    class Nonce
      def self.next
        SecureRandom.hex()
      end
    end
  end
end