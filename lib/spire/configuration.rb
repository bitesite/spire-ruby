module Spire
  class Configuration
    CONFIGURABLE_ATTRIBUTES = [
      :company,
      :username,
      :password,
      :host,
      :port
    ]

    attr_accessor *CONFIGURABLE_ATTRIBUTES

    def self.configurable_attributes
      CONFIGURABLE_ATTRIBUTES
    end

    def initialize(attrs = {})
      attrs[:port] = 10880 if attrs[:port].nil?
      self.attributes = attrs
    end

    def attributes=(attrs = {})
      attrs.each { |key, value| instance_variable_set("@#{key}", value) }
    end

    def credentials
      case
      when basic?
        basic_credentials
      else
        {}
      end
    end

    def basic?
      username && password
    end

    private
      def basic_credentials
        {
          username: username,
          password: password
        }
      end
  end
end