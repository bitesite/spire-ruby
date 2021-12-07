module Spire
  module Inventory
    # A Receipt
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [r] receiptNo
    #   @return [int]
    # @!attribute [r] inventory_id
    #   @return [int]
    # @!attribute [r] whse
    #   @return [String]
    # @!attribute [r] partNo
    #   @return [String]
    # @!attribute [r] vendorNo
    #   @return [String]
    # @!attribute [r] vendorName
    #   @return [String]
    # @!attribute [r] date
    #   @return [String]
    # @!attribute [r] location
    #   @return [String]
    # @!attribute [r] quantity
    #   @return [String]
    # @!attribute [r] stockMeasure
    #   @return [String]
    # @!attribute [r] receiptMeasureQty
    #   @return [String]
    # @!attribute [r] receiptMeasure
    #   @return [String]
    # @!attribute [r] costPrice
    #   @return [String]
    # @!attribute [r] sellPrice
    #   @return [String]
    # @!attribute [r] linkTable
    #   @return [String]
    # @!attribute [r] linkNo
    #   @return [String]
    # @!attribute [r] linkGuid
    #   @return [String]
    # @!attribute [r] refNo
    #   @return [String]
    # @!attribute [r] user
    #   @return [String]
    # @!attribute [r] remainingQty
    #   @return [String]
    class Receipt < BasicData
      register_attributes :id,
                          :receiptNo,
                          :inventory_id,
                          :whse,
                          :partNo,
                          :vendorNo,
                          :vendorName,
                          :date,
                          :location,
                          :quantity,
                          :stockMeasure,
                          :receiptMeasureQty,
                          :receiptMeasure,
                          :costPrice,
                          :sellPrice,
                          :linkTable,
                          :linkNo,
                          :linkGuid,
                          :refNo,
                          :user,
                          :remainingQty,
                          readonly: [
                            :id,
                            :receiptNo,
                            :inventory_id,
                            :whse,
                            :partNo,
                            :vendorNo,
                            :vendorName,
                            :date,
                            :location,
                            :quantity,
                            :stockMeasure,
                            :receiptMeasureQty,
                            :receiptMeasure,
                            :costPrice,
                            :sellPrice,
                            :linkTable,
                            :linkNo,
                            :linkGuid,
                            :refNo,
                            :user,
                            :remainingQty
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
