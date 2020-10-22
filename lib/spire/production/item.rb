module Spire
  module Production
    # An Order is a record that belongs to a Customer
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [r] order
    #   @return [Hash]
    # @!attribute [r] whse
    #   @return [String]
    # @!attribute [r] part_no
    #   @return [String]
    # @!attribute [r] description
    #   @return [String]
    # @!attribute [r] unit_qty
    #   @return [String]
    # @!attribute [r] extended_qty
    #   @return [String]
    # @!attribute [r] committed_qty
    #   @return [String]
    # @!attribute [r] template_no
    #   @return [String]
    # @!attribute [r] created
    #   @return [String]
    # @!attribute [r] modified
    #   @return [String]
    # @!attribute [r] created_by
    #   @return [String]
    # @!attribute [r] modified_by
    #   @return [String]
    class Item < BasicData
      register_attributes :id, 
                          :order, 
                          :whse,
                          :part_no,
                          :description,
                          :unit_qty,
                          :extended_qty,
                          :committed_qty,
                          :template_no,
                          :created,
                          :modified,
                          :created_by,
                          :modified_by,
                          readonly: [
                            :id, 
                            :order, 
                            :whse,
                            :part_no,
                            :description,
                            :unit_qty,
                            :extended_qty,
                            :committed_qty,
                            :template_no,
                            :created,
                            :modified,
                            :created_by,
                            :modified_by
                          ]

      SYMBOL_TO_STRING = {
        id: 'id',
        order: 'order',
        whse: 'whse',
        part_no: 'partNo',
        description: 'description',
        unit_qty: 'unitQty',
        extended_qty: 'extendedQty',
        committed_qty: 'committedQty',
        template_no: 'templateNo',
        created: 'created',
        modified: 'modified',
        created_by: 'createdBy',
        modified_by: 'modifiedBy',
      }

      class << self
        # Get all orders
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Production::Item]
        def all
          client.find_many(Spire::Production::Item, "/production/items/", {})
        end

        # Find a specific order by its id.
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Production::Item]
        def find(id, params = {})
          client.find("/production/items", id, params)
        end

        # Search for order by query. This will even return inactive orders!
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Production::Item]
        def search(query)
          client.find_many(Spire::Production::Item, "/production/items/", { q: query })
        end
      end

      # Update the fields of an order.
      #
      # Supply a hash of string keyed data retrieved from the Spire API representing an order.
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
