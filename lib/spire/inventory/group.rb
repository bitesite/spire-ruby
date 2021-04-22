module Spire
  module Inventory
    # An Order is a record that belongs to a Customer
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [r] code
    #   @return [String]
    # @!attribute [r] description
    #   @return [String]
    # @!attribute [r] margin
    #   @return [String]
    # @!attribute [r] service_charge
    #   @return [String]
    class Group < BasicData
      register_attributes :id, 
                          :code,
                          :description,
                          :margin,
                          :service_charge,
                          readonly: [
                            :id,
                            :code,
                            :description,
                            :margin,
                            :service_charge,
                          ]

      SYMBOL_TO_STRING = {
        id: 'id',
        code: 'code',
        description: 'description',
        margin: 'margin',
        service_charge: 'serviceCharge',
      }

      class << self
        # Find a specific group by its id.
        #
        # @raise [Spire::Error] if the group could not be found.
        #
        # @return [Spire::Inventory::Group]
        def find(id, params = {})
          # client.find("/inventory/groups", id, params)
          raise Error.new('Spire API does not currently support finding groups by ID', 404)
        end

        # Find many groups
        #
        # You can pass in options like q, limit, filter and any other
        # parameters that are supported by the Spire API
        #
        # @return [Spire::Inventory::Group]
        def find_many(options = {})
          client.find_many(Spire::Inventory::Group, "/inventory/groups/", options)
        end

        # Search for group by query
        #
        # @raise [Spire::Error] if the group could not be found.
        #
        # @return [Spire::Inventory::Group]
        def search(query)
          client.find_many(Spire::Inventory::Group, "/inventory/groups/", { q: query })
        end
      end

      # Update the fields of an group.
      #
      # Supply a hash of string keyed data retrieved from the Spire API representing an group.
      #
      # Note that this method does not save anything new to the Spire API,
      # it just assigns the input attributes to your local object. If you use
      # this method to assign attributes, call `save` or `update!` afterwards if
      # you want to persist your changes to Spire.
      #
      def update_fields(fields)
        # instead of going through each attribute on self, iterate through each item in field and update from there
        self.attributes.each do |k, v|
          attributes[k.to_sym] = fields[SYMBOL_TO_STRING[k.to_sym]] || fields[k.to_sym] || attributes[k.to_sym]
        end

        attributes[:id] = fields[SYMBOL_TO_STRING[:id]] || attributes[:id]
        self
      end
    end
  end
end
