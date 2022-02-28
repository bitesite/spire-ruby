module Spire
  module Purchasing
    # An Order is a record that belongs to a Customer
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [r] number
    #   @return [String]
    # @!attribute [rw] vendor
    #   @return [Hash]
    # @!attribute [r] currency
    #   @return [Hash]
    # @!attribute [r] status
    #   @return [String]
    # @!attribute [r] date
    #   @return [String]
    # @!attribute [r] address
    #   @return [Hash]
    # @!attribute [r] shippingAddress
    #   @return [Hash]
    # @!attribute [r] vendorPO
    #   @return [String]
    # @!attribute [r] referenceNo
    #   @return [String]
    # @!attribute [r] fob
    #   @return [String]
    # @!attribute [r] incoterms
    #   @return [int]
    # @!attribute [r] incotermsPlace
    #   @return [int]
    # @!attribute [r] subtotal
    #   @return [String]
    # @!attribute [r] total
    #   @return [String]
    # @!attribute [r] items
    #   @return [Array]
    # @!attribute [r] udf
    #   @return [Hash]
    # @!attribute [r] created
    #   @return [String]
    # @!attribute [r] modified
    #   @return [String]
    # @!attribute [r] created_by
    #   @return [String]
    # @!attribute [r] modified_by
    #   @return [String]
    class Order < BasicData
      register_attributes :id, :number, :vendor, :currency, :status, :date,
        :address, :shipping_address, :vendor_po, :reference_no, :fob,
        :incoterms, :incoterms_place, :subtotal, :total, :items, :udf,
        :created_by, :modified_by, :created, :modified,
        readonly: [
          :created_by,
          :modified_by,
          :created,
          :modified,
        ]

      SYMBOL_TO_STRING = {
        id: "id",
        number: "number",
        vendor: "vendor",
        currency: "currency",
        status: "status",
        date: "date",
        address: "address",
        shipping_address: "shippingAddress",
        vendor_po: "vendorPO",
        reference_no: "referenceNo",
        fob: "fob",
        incoterms: "incoterms",
        incoterms_place: "incotermsPlace",
        subtotal: "subtotal",
        total: "total",
        items: "items",
        udf: "udf",
        created_by: "createdBy",
        modified_by: "modifiedBy",
        created: "created",
        modified: "modified",
      }

      class << self
        # Get all orders
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Purchasing::Order]
        def all
          client.find_many(Spire::Purchasing::Order, "/purchasing/orders/", {})
        end

        # Find a specific order by its id.
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Purchasing::Order]

        def find(id, params = {})
          client.find("/purchasing/orders", id, params)
        end

        # Create a new item and save it on Spire.
        #
        # @param [Hash] options
        # @option options [Hash] :address this is the billing address for the customer
        # @option options [Hash] :shipping_address this is the shipping address that the order will be sent to (defaults to the billing address if none provided)
        # @option options [Array] :items this is an array of hashes that will accept an inventory item that will have a hash example input from the web client: items: [ { "inventory": {"id": 123} } ]
        # this array can also accept a desctiption and comment object that will create a comment on the order itself ex: items: [{"description":"MAKE COMMENT THRU API","comment":"MAKE COMMENT THRU API"}]
        # @option options [Hash] :udf, this is a hash for the user defined fields created by a user:  "udf" : { "ready_to_ship":"YES", "credit_card_charged": "NO", ... }

        # @raise [Spire::Error] if the order could not be created.
        #
        # @return [Spire::Order]

        def create(options)
          client.create(
            "/purchasing/orders",
            "vendor" => options[:vendor],
            "currency" => options[:currency],
            "status" => options[:status],
            "date" => options[:date],
            "address" => options[:address],
            "shippingAddress" => options[:shipping_address],
            "vendorPO" => options[:vendor_po],
            "referenceNo" => options[:reference_no],
            "fob" => options[:fob],
            "incoterms" => options[:incoterms],
            "incotermsPlace" => options[:incoterms_place],
            "items" => options[:items],
            "udf" => options[:udf],
          )
        end

        # Find many orders
        #
        # You can pass in options like q, limit, filter and any other
        # parameters that are supported by the Spire API
        #
        # @return [Spire::Production::Order]
        def find_many(options = {})
          client.find_many(Spire::Purchasing::Order, "/purchasing/orders/", options)
        end

        # Search for order by query. This will even return inactive orders!
        #
        # @raise [Spire::Error] if the order could not be found.
        #
        # @return [Spire::Production::Order]
        def search(query)
          client.find_many(Spire::Purchasing::Order, "/purchasing/orders/", { q: query })
        end
      end

      # Saves a record.
      # @raise [Spire::Error] if the order could not be saved
      # @return [String] The JSON representation of the saved order returned by
      # the Spire API.
      def save
        # If we have an id, just update our fields
        return update! if id

        options = {
          vendor: vendor || {},
          currency: currency || {},
          status: status,
          date: date,
          address: address || {},
          shippingAddress: shipping_address || {},
          vendorPO: vendor_po,
          referenceNo: reference_no,
          fob: fob,
          incoterms: incoterms,
          incotermsPlace: incoterms_place,
          items: items || [],
          udf: udf || {},
        }

        from_response client.post("/purchasing/orders/", options)
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

      # Delete this order
      # @return [String] the JSON response from the Spire API
      def delete
        client.delete("/purchasing/orders/#{id}")
      end
    end
  end
end
