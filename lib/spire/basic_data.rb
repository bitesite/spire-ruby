require "active_support/inflector"

module Spire
  class BasicData
    include ActiveModel::Validations
    include ActiveModel::Dirty
    include ActiveModel::Serializers::JSON

    include Spire::JsonUtils

    attr_writer :client

    class << self
      def save(options)
        new(options).tap do |basic_data|
          yield basic_data if block_given?
        end.save
      end

      def parse(response)
        from_response(response).tap do |basic_data|
          yield basic_data if block_given?
        end
      end

      def parse_many(response)
        from_response(response).map do |data|
          data.tap do |d|
            yield d if block_given?
          end
        end
      end

      def register_attributes(*names)
        options = { readonly: [] }
        options.merge!(names.pop) if names.last.kind_of? Hash

        # Defines the attribute getter and setters.
        class_eval do
          define_method :attributes do
            # custom instance variable to prevent Dirty to use ActiveModel::AttributeMutationTracker
            @_attributes ||= names.reduce({}) { |hash, k| hash.merge(k.to_sym => nil) }
          end

          names.each do |key|
            define_method(:"#{key}") { @_attributes[key] }

            unless options[:readonly].include?(key.to_sym)
              define_method :"#{key}=" do |val|
                send(:"#{key}_will_change!") unless val == @_attributes[key]
                @_attributes[key] = val
              end
            end
          end

          define_attribute_methods names
        end
      end

      def one(name, opts = {})
        class_eval do
          define_method(:"#{name}") do |*args|
            options = opts.dup
            klass = options.delete(:via) || Spire.const_get(name.to_s.camelize)
            ident = options.delete(:using) || :id
            path = options.delete(:path)

            if path
              client.find(path, self.send(ident))
            else
              klass.find(self.send(ident))
            end
          end
        end
      end

      def many(name, opts = {})
        class_eval do
          define_method(:"#{name}") do |*args|
            options = opts.dup
            resource = options.delete(:in) || self.class.to_s.split("::").last.downcase.pluralize
            klass = options.delete(:via) || Spire.const_get(name.to_s.singularize.camelize)
            path = options.delete(:path) || name
            params = options.merge(args[0] || {})

            resources = client.find_many(klass, "/#{resource}/#{id}/#{path}", params)
            MultiAssociation.new(self, resources).proxy
          end
        end
      end

      def client
        Spire.client
      end
    end

    register_attributes :id, readonly: [:id]

    def initialize(fields = {})
      update_fields(fields)
    end

    def update_fields(_fields)
      raise NotImplementedError, "#{self.class} does not implement update_fields."
    end

    # Refresh the contents of our object.
    def refresh!
      self.class.find(id)
    end

    # Two objects are equal if their _id_ methods are equal.
    def ==(other)
      id == other.id
    end

    def client
      @client ||= self.class.client
    end

    private

      def clear_changes
        @changed_attributes.clear if @changed_attributes.respond_to?(:clear)
        changes_applied if respond_to?(:changes_applied)
      end
  end
end
