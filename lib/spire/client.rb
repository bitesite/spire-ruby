require 'uri'
require 'cgi'
require 'forwardable'
require 'active_support/inflector'

module Spire
  class Client
    extend Forwardable
    include Authorization

    def_delegators :configuration, :credentials, *Configuration.configurable_attributes

    def initialize(attrs = {})
      self.configuration.attributes = attrs
    end

    def get(path, params = {})
      uri = api_uri(path)
      uri.query = URI.encode_www_form(params) unless params.empty?
      invoke_verb(:get, uri)
    end

    def post(path, body = {})
      invoke_verb(:post, api_uri(path), body)
    end

    def put(path, body = {})
      invoke_verb(:put, api_uri(path), body)
    end

    def delete(path)
      invoke_verb(:delete, api_uri(path))
    end

    # Finds given resource by id
    #
    # Examples:
    #   client.find('/inventory/items', 1)
    #
    def find(path, id, params = {})
      response = get("#{path}/#{id}", params)
      spire_class = class_from_path(path)
      spire_class.parse response do |data|
        data.client = self
      end
    end

    # Finds given resources by path with params
    def find_many(spire_class, path, params = {})
      response = get(path, params)
      spire_class.parse_many response do |data|
        data.client = self
      end
    end

    # Creates resource with given options (attributes)
    #
    # Examples:
    #   client.create(:item, options)
    #
    def create(path, options)
      spire_class = class_from_path(path)
      spire_class.save options do |data|
        data.client = self
      end
    end

    def configure
      yield configuration if block_given?
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def auth_policy
      @auth_policy ||= auth_policy_class.new(credentials)
    end

    private
      def invoke_verb(name, uri, body = nil)
        request = Request.new name, uri, {"Content-Type"=>"application/json; charset=UTF-8"}, body
        response = SInternet.execute auth_policy.authorize(request)

        return '' unless response

        unless [200, 201].include? response.code
          Spire.logger.error("[#{response.code} #{name.to_s.upcase} #{uri}]: #{response.body}")
          raise Error.new(response.body, response.code)
        end

        response.body
      end

      def auth_policy_class
        if configuration.basic?
          BasicAuthPolicy
        else
          AuthPolicy
        end
      end

      def class_from_path(path_or_class)
        return path_or_class if path_or_class.is_a?(Class)

        if path_or_class == '/inventory/items'
          Spire.const_get('Item')
        elsif path_or_class == '/sales/orders'
          Spire.const_get('Order')
        elsif path_or_class == '/sales/invoices'
          Spire.const_get('Invoice')
        elsif path_or_class == '/inventory/upcs'
          Spire.const_get('Upc')
        elsif path_or_class =='/inventory/groups'
          Spire.const_get('Inventory::Group')
        elsif path_or_class == '/crm/notes'
          Spire.const_get('Note')
        elsif path_or_class =='/production/orders'
          Spire.const_get('Production::Order')
        elsif path_or_class =='/production/items'
          Spire.const_get('Production::Item')
        elsif path_or_class =='/production/templates'
          Spire.const_get('Production::Template')
        elsif path_or_class =='/production/template_items'
          Spire.const_get('Production::TemplateItem')
        else
          Spire.const_get(path_or_class.to_s.singularize.camelize.gsub('::', ''))
        end
      end

      def api_uri(path)
        URI("https://#{self.configuration.host}:#{self.configuration.port}/api/v#{API_VERSION}/companies/#{self.configuration.company}#{path}")
      end
  end
end