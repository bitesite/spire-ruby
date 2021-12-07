module Spire
  module Inventory
    # A Receipt
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [r] receipt_no
    #   @return [int]
    # @!attribute [r] inventory_id
    #   @return [int]
    # @!attribute [r] whse
    #   @return [String]
    # @!attribute [r] part_no
    #   @return [String]
    # @!attribute [r] vendor_no
    #   @return [String]
    # @!attribute [r] vendor_name
    #   @return [String]
    # @!attribute [r] date
    #   @return [String]
    # @!attribute [r] location
    #   @return [String]
    # @!attribute [r] quantity
    #   @return [String]
    # @!attribute [r] stock_measure
    #   @return [String]
    # @!attribute [r] receipt_measure_qty
    #   @return [String]
    # @!attribute [r] receipt_measure
    #   @return [String]
    # @!attribute [r] cost_price
    #   @return [String]
    # @!attribute [r] sell_price
    #   @return [String]
    # @!attribute [r] link_table
    #   @return [String]
    # @!attribute [r] link_no
    #   @return [String]
    # @!attribute [r] link_guid
    #   @return [String]
    # @!attribute [r] ref_no
    #   @return [String]
    # @!attribute [r] user
    #   @return [String]
    # @!attribute [r] remaining_qty
    #   @return [String]
    class Receipt < BasicData
      register_attributes :id,
                          :receipt_no,
                          :inventory_id,
                          :whse,
                          :part_no,
                          :vendor_no,
                          :vendor_name,
                          :date,
                          :location,
                          :quantity,
                          :stock_measure,
                          :receipt_measure_qty,
                          :receipt_measure,
                          :cost_price,
                          :sell_price,
                          :link_table,
                          :link_no,
                          :link_guid,
                          :ref_no,
                          :user,
                          :remaining_qty,
                          readonly: [
                            :id,
                            :receipt_no,
                            :inventory_id,
                            :whse,
                            :part_no,
                            :vendor_no,
                            :vendor_name,
                            :date,
                            :location,
                            :quantity,
                            :stock_measure,
                            :receipt_measure_qty,
                            :receipt_measure,
                            :cost_price,
                            :sell_price,
                            :link_table,
                            :link_no,
                            :link_guid,
                            :ref_no,
                            :user,
                            :remaining_qty
                          ]

      SYMBOL_TO_STRING = {
        id: "id",
        receipt_no: "receiptNo",
        inventory_id: "inventory_id",
        whse: "whse",
        part_no: "partNo",
        vendor_no: "vendorNo",
        vendor_name: "vendorName",
        date: "date",
        location: "location",
        quantity: "quantity",
        stock_measure: "stockMeasure",
        receipt_measure_qty: "receiptMeasureQty",
        receipt_measure: "receiptMeasure",
        cost_price: "costPrice",
        sell_price: "sellPrice",
        link_table: "linkTable",
        link_no: "linkNo",
        link_guid: "linkGuid",
        ref_no: "refNo",
        user: "user",
        remaining_qty: "remainingQty"
      }

      class << self
        # Find a specific order by its id.
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Inventory::Receipt]
        def find(id, params = {})
          raise Error.new('Spire API does not currently support finding Receipts by ID', 404)
        end

        # Find many items
        #
        # You can pass in options like q, limit, filter and any other
        # parameters that are supported by the Spire API
        #
        # @return [Spire::Inventory::Receipt]
        def find_many(options = {})
          client.find_many(Spire::Inventory::Receipt, "/inventory/receipts/", options)
        end

        # Search for order by query. This will even return inactive orders!
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Inventory::Receipt]
        def search(query)
          client.find_many(Spire::Inventory::Receipt, "/inventory/receipts/", { q: query })
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
