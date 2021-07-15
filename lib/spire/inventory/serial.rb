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
    class Serial < BasicData
      register_attributes :id, 
                          :serial_number,
                          :whse,
                          :part_no,
                          :inventory,
                          :closed,
                          :unit_cost,
                          :received_date,
                          :expiry_date,
                          :available_qty,
                          :committed_qty,
                          :temp_qty,
                          :hold,
                          :sell_price,
                          readonly: [
                            :id, 
                            :serial_number,
                            :whse,
                            :part_no,
                            :inventory,
                            :closed,
                            :unit_cost,
                            :received_date,
                            :expiry_date,
                            :available_qty,
                            :committed_qty,
                            :temp_qty,
                            :hold,
                            :sell_price,
                          ]

      SYMBOL_TO_STRING = {
        id: 'id',  
        serial_number: 'serialNumber',
        whse: 'whse',
        part_no: 'partNo',
        inventory: 'inventory',
        closed: 'closed',
        unit_cost: 'unitCost',
        received_date: 'receivedDate',
        expiry_date: 'expiryDate',
        available_qty: 'availableQty',
        committed_qty: 'committedQty',
        temp_qty: 'tempQty',
        hold: 'hold',
        sell_price: 'sellPrice',
      }

      class << self
        # Find a specific Serial by its id.
        #
        # @raise [Spire::Error] if the Serial could not be found.
        #
        # @return [Spire::Inventory::Serial]
        def find(id, params = {})
          # client.find("/inventory/Serials", id, params)
          raise Error.new('Spire API does not currently support finding Serials by ID', 404)
        end

        # Find many Serials
        #
        # You can pass in options like q, limit, filter and any other
        # parameters that are supported by the Spire API
        #
        # @return [Spire::Inventory::Serial]
        def find_many(options = {})
          client.find_many(Spire::Inventory::Serial, "/inventory/serials/", options)
        end

        # Search for Serial by query
        #
        # @raise [Spire::Error] if the Serial could not be found.
        #
        # @return [Spire::Inventory::Serial]
        def search(query)
          client.find_many(Spire::Inventory::Serial, "/inventory/serials/", { q: query })
        end
      end

      # Update the fields of an Serial.
      #
      # Supply a hash of string keyed data retrieved from the Spire API representing an Serial.
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
