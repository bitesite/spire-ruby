module Spire
  module Inventory
    # A warehouse is a record that categorizes inventory items.
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [r] code
    #   @return [String]
    # @!attribute [r] description
    #   @return [String]
    class Warehouse < BasicData
      register_attributes :id,
                          :code,
                          :description,
                          readonly: [
                            :id,
                            :code,
                            :description,
                          ]

      SYMBOL_TO_STRING = {
        id: "id",
        code: "code",
        description: "description",
      }

      class << self
        # Find a specific warehouse by its id.
        #
        # @raise [Spire::Error] if the warehouse could not be found.
        #
        # @return [Spire::Inventory::Warehouse]
        def find(id, params = {})
          # client.find("/inventory/warehouses", id, params)
          raise Error.new("Spire API does not currently support finding warehouses by ID", 404)
        end

        # Find many warehouses
        #
        # You can pass in options like q, limit, filter and any other
        # parameters that are supported by the Spire API
        #
        # @return [Spire::Inventory::Warehouse]
        def find_many(options = {})
          client.find_many(Spire::Inventory::Warehouse, "/inventory/warehouses/", options)
        end

        # Search for warehouse by query
        #
        # @raise [Spire::Error] if the warehouse could not be found.
        #
        # @return [Spire::Inventory::Warehouse]
        def search(query)
          client.find_many(Spire::Inventory::Warehouse, "/inventory/warehouses/", { q: query })
        end
      end

      # Update the fields of an warehouse.
      #
      # Supply a hash of string keyed data retrieved from the Spire API representing an warehouse.
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
