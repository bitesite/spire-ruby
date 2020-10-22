module Spire
  module Production
    # An Order is a record that belongs to a Customer
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [r] order_no
    #   @return [String]
    # @!attribute [r] whse
    #   @return [String]
    # @!attribute [r] part_no
    #   @return [String]
    # @!attribute [r] description
    #   @return [String]
    # @!attribute [r] order_date
    #   @return [String]
    # @!attribute [r] required_date
    #   @return [String]
    # @!attribute [r] required_qty
    #   @return [String]
    # @!attribute [r] backorder_qty
    #   @return [String]
    # @!attribute [r] parts_cost
    #   @return [String]
    # @!attribute [r] priority
    #   @return [int]
    # @!attribute [r] yield_expected_pct
    #   @return [String]
    # @!attribute [r] yield_actual_qty
    #   @return [String]
    # @!attribute [r] assemble_qty
    #   @return [String]
    # @!attribute [r] assembled_qty
    #   @return [String]
    # @!attribute [r] created
    #   @return [String]
    # @!attribute [r] modified
    #   @return [String]
    # @!attribute [r] created_by
    #   @return [String]
    # @!attribute [r] modified_by
    #   @return [String]
    class Order < BasicData
      register_attributes :id,
                          :order_no,
                          :whse,
                          :part_no,
                          :description,
                          :order_date,
                          :required_date,
                          :required_qty,
                          :backorder_qty,
                          :parts_cost,
                          :priority,
                          :yield_expected_pct,
                          :yield_actual_qty,
                          :assemble_qty,
                          :assembled_qty,
                          :created_by,
                          :modified_by,
                          :created,
                          :modified,
                          readonly: [
                            :id,
                            :order_no,
                            :whse,
                            :part_no,
                            :description,
                            :order_date,
                            :required_date,
                            :required_qty,
                            :backorder_qty,
                            :parts_cost,
                            :priority,
                            :yield_expected_pct,
                            :yield_actual_qty,
                            :assemble_qty,
                            :assembled_qty,
                            :created_by,
                            :modified_by,
                            :created,
                            :modified
                          ]

      SYMBOL_TO_STRING = {
        id: "id",
        order_no: "orderNo",
        whse: "whse",
        part_no: "partNo",
        description: "description",
        order_date: "orderDate",
        required_date: "requiredDate",
        required_qty: "requiredQty",
        backorder_qty: "backorderQty",
        parts_cost: "partsCost",
        priority: "priority",
        yield_expected_pct: "yieldExpectedPct",
        yield_actual_qty: "yield_actualQty",
        assemble_qty: "assembleQty",
        assembled_qty: "assembledQty",
        created_by: "createdBy",
        modified_by: "modifiedBy",
        created: "created",
        modified: "modified"
      }

      class << self
        # Get all orders
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Production::Order]
        def all
          client.find_many(Spire::Production::Order, "/production/orders/", {})
        end

        # Find a specific order by its id.
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Production::Order]
        def find(id, params = {})
          client.find("/production/orders", id, params)
        end

        # Search for order by query. This will even return inactive orders!
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Production::Order]
        def search(query)
          client.find_many(Spire::Production::Order, "/production/orders/", { q: query })
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
