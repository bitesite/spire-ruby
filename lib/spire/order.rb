module Spire
  # An Order is a record that belongs to a Customer
  #
  # @!attribute [r] id
  #   @return [int]
  # @!attribute [rw] order_no
  #   @return [String]
  # @!attribute [rw] customer
  #   @return [Hash]
  # @!attribute [rw] status
  #   @return [string]
  # @!attribute [rw] type
  #   @return [String]
  # @!attribute [rw] hold
  #   @return [Boolean]
  # @!attribute [rw] order_date
  #   @return [String]
    # @!attribute [rw] required_date
  #   @return [String]
  # @!attribute [rw] address
  #   @return [Hash]
  # @!attribute [rw] shipping_address
  #   @return [Hash]
  # @!attribute [rw] customer_po
  #   @return [String]
  # @!attribute [rw] fob
  #   @return [String]
  # @!attribute [rw] terms_code
  #   @return [String]
  # @!attribute [rw] terms_text
  #   @return [String]
  # @!attribute [rw] reference_no
  #   @return [String]
  # @!attribute [rw] freight
  #   @return [String]
  # @!attribute [rw] taxes
  #   @return [Array]
  # @!attribute [rw] subtotal
  #   @return [String]
  # @!attribute [rw] subtotal_ordered
  #   @return [String]
  # @!attribute [rw] discount
  #   @return [String]
  # @!attribute [rw] total_discount
  #   @return [String]
  # @!attribute [rw] total
  #   @return [String]
  # @!attribute [rw] total_ordered
  #   @return [String]
  # @!attribute [rw] gross_profit
  #   @return [String]
  # @!attribute [rw] items
  #   @return [Array]
  # @!attribute [rw] payments
  #   @return [Array]
  # @!attribute [rw] contact
  #   @return [Hash]
  # @!attribute [r] created
  #   @return [String]
  # @!attribute [r] modified
  #   @return [String]
  # @!attribute [rw] background_color
  #   @return [String]
  # @!attribute [r] created_by
  #   @return [String]
  # @!attribute [r] modified_by
  #   @return [String]
  # @!attribute [r] deleted_by
  #   @return [String]
  # @!attribute [r] delete
  #   @return [String]
  # @!attribute [rw] shipping_carrier
  #   @return [String]
  # @!attribute [rw] tracking_no
  #   @return [String]
  # @!attribute [rw] udf
  #   @return [Hash]
  class Order < BasicData
    register_attributes :id, :order_no, :customer, :status, :type, :hold,
      :order_date, :required_date, :address, :shipping_address, :customer_po, :reference_no, :fob, :terms_code,
      :terms_text, :freight, :taxes, :subtotal, :subtotal_ordered, :discount,
      :total_discount, :total, :total_ordered, :gross_profit, :items, :payments, :contact, :created_by,
      :modified_by, :created, :modified, :background_color, :deleted_by, :deleted, :udf,
      :shipping_carrier, :tracking_no,
      readonly: [
        :created_by, :modified_by, :created, :modified, :deleted_by,
        :deleted,
      ]

    validates_presence_of :id, :customer, :address, :shipping_address, :items

    # Canceling an order on Web is the HOLD function in the spire client
    ACTIVE = false
    ON_HOLD = true

    #Statuses - These are to track the flow of the order throughout its lifespan
    OPEN = "O"
    PROCESSED = "P"
    DEPOSITED = "L"

    SYMBOL_TO_STRING = {
      id: "id",
      order_no: "orderNo",
      customer: "customer",
      status: "status",
      type: "type",
      hold: "hold",
      order_date: "orderDate",
      required_date: "requiredDate",
      address: "address",
      shipping_address: "shippingAddress",
      customer_po: "customerPO",
      fob: "fob",
      reference_no: "referenceNo",
      terms_code: "termsCode",
      terms_text: "termsText",
      freight: "freight",
      taxes: "taxes",
      subtotal: "subtotal",
      subtotal_ordered: "subtotalOrdered",
      discount: "discount",
      total_discount: "totalDiscount",
      total: "total",
      total_ordered: "totalOrdered",
      gross_profit: "grossProfit",
      items: "items",
      payments: "payments",
      contact: "contact",
      created_by: "createdBy",
      modified_by: "modifiedBy",
      created: "created",
      modified: "modified",
      background_color: "backgroundColor",
      deleted_by: "deletedBy",
      deleted: "deleted",
      shipping_carrier: "shippingCarrier",
      tracking_no: "trackingNo",
      udf: "udf",
    }

    class << self
      # Find a specific order by its id.
      #
      # @raise [Spire::Error] if the order could not be found.
      #
      # @return [Spire::Order]
      def find(id, params = {})
        client.find("/sales/orders", id, params)
      end

      # Search for order by query. This will even return inactive orders!
      #
      # @raise [Spire::Error] if the order could not be found.
      #
      # @return [Spire::Order]
      def search(query)
        client.find_many(Spire::Order, "/sales/orders/", { q: query })
      end

      # Create a new item and save it on Spire.
      #
      # @param [Hash] options
      # @option options [Hash] :customer the spire customer who will be associated with the order
      # @option options [Hash] :address this is the billing address for the customer
      # @option options [Hash] :shipping_address this is the shipping address that the order will be sent to (defaults to the billing address if none provided)
      # @option options [Array] :items this is an array of hashes that will accept an inventory item that will have a hash example input from the web client: items: [ { "inventory": {"id": 123} } ]
      # this array can also accept a desctiption and comment object that will create a comment on the order itself ex: items: [{"description":"MAKE COMMENT THRU API","comment":"MAKE COMMENT THRU API"}]
      # @option options [String] :discount this is the discount percentage for that order
      # @option options [String] :terms_code used to prepare the order for the deposit by marking the order with the appropriate pre-payment method used
      # @option options [String] :freight this is the shipping cost for that order
      # @option options [String] :customerPO this is the purchase order number for internal use
      # @option options [String] :reference_no this is the reference number for the order
      # @option options [String] :type this is used to distinguish between it is an order ("O") or quote ("Q")
      # @option options [Array] :payments, specifies the payment type by customer for a deposit "payments" : [{"method" : 2 }]
      # @option options [Hash] :contact, this is a hash for a customer's contact:  "contact" : { "phone":{"number":"123", "format":2}, "name":"John Doe", "email":"jd@example.com" }
      # @option options [String] :shipping_carrier, this carrier used to ship the order
      # @option options [String] :tracking_no, the tracking number associated with the order shipment
      # @option options [Hash] :udf, this is a hash for the user defined fields created by a user:  "udf" : { "ready_to_ship":"YES", "credit_card_charged": "NO", ... }

      # @raise [Spire::Error] if the order could not be created.
      #
      # @return [Spire::Order]
      def create(options)

        create_attributes = {
          "customer" => options[:customer],
          "status" => options[:status],
          "termsCode" => options[:terms_code],
          "address" => options[:address],
          "shippingAddress" => options[:shipping_address],
          "items" => options[:items],
          "discount" => options[:discount],
          "freight" => options[:freight],
          "customerPO" => options[:customer_po],
          "referenceNo" => options[:reference_no],
          "type" => options[:type],
          "contact" => options[:contact],
          "payments" => options[:payments],
          "shippingCarrier" => options[:shipping_carrier],
          "trackingNo" => options[:tracking_no],
          "udf" => options[:udf],
          "orderDate" => options[:order_date],
          "requiredDate" => options[:required_date],
        }
        
        create_attributes["orderNo"] = options[:order_no] if options[:order_no]
        create_attributes["orderDate"] = options[:order_date] if options[:order_date]
        create_attributes["requiredDate"] = options[:required_date] if options[:required_date]

        client.create(
          :order,
          create_attributes
        )
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
    # @param [Hash] fields
    # @option fields [Hash] :customer The customer object that we will pass to spire
    # @option fields [String] :status
    # @option fields [String] :type
    # @option fields [Boolean] :hold
    # @option fields [String] :order_date
    # @option fields [String] :required_date
    # @option fields [Hash] :address This is the Billing Address for the customer
    # @option fields [Hash] :shipping_address This is the shipping address, if none provided it will default to the billing address
    # @option fields [String] :customer_po
    # @option fields [String] :reference_no
    # @option fields [String] :fob
    # @option fields [String] :terms_code
    # @option fields [String] :terms_text
    # @option fields [String] :freight
    # @option fields [Array] :taxes
    # @option fields [String] :subototal
    # @option fields [String] :subtotal_ordered
    # @option fields [String] :discount
    # @option fields [String] :freight
    # @option fields [String] :customerPO
    # @option fields [String] :type
    # @option fields [String] :total_discount
    # @option fields [String] :total
    # @option fields [String] :total_ordered
    # @option fields [String] :gross_profit
    # @option fields [Array] :items This will be an array of hashes, where if inventory is null and a comment option is provided, it will create a "Comment" on the order instead of a line item
    # @option fields [String] :background_color - the sync color that we use in spire
    # @option fields [Array] :payments - accepts simple payment method code id, which denotes payment type, used for marking payment deposited.
    # @option fields [Hash] :contact
    # @option fields [String] :shipping_carrier
    # @option fields [String] :tracking_no
    # @option fields [Hash] :udf
    def update_fields(fields)
      # instead of going through each attribute on self, iterate through each item in field and update from there
      self.attributes.each do |k, v|
        attributes[k.to_sym] = fields[SYMBOL_TO_STRING[k.to_sym]] || fields[k.to_sym] || attributes[k.to_sym]
      end

      attributes[:id] = fields[SYMBOL_TO_STRING[:id]] || attributes[:id]
      self
    end

    # Saves a record.
    #
    # @raise [Spire::Error] if the order could not be saved
    #
    # @return [String] The JSON representation of the saved order returned by
    #     the Spire API.
    def save
      # If we have an id, just update our fields
      return update! if id

      options = {
        customer: customer || {},
        address: address || {},
        shippingAddress: shipping_address || {},
        items: items || {},
        discount: discount || "0",
        freight: freight || "",
        customerPO: customer_po || "",
        referenceNo: reference_no || "",
        type: type || "O",
        termsCode: terms_code || "",
        hold: hold || ACTIVE,
        payments: payments || [],
        contact: contact || {},
        shippingCarrier: shipping_carrier,
        trackingNo: tracking_no,
        status: status || OPEN,
        backgroundColor: background_color || 16777215,
        udf: udf || {},
      }

      options[:orderNo] = order_no if order_no
      options[:orderDate] = order_date if order_date
      options[:requiredDate] = required_date if required_date
      
      from_response client.post("/sales/orders/", options)
    end

    # Update an existing record.
    #
    # Warning: this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh with update fields method!
    # this object before making your changes, and before updating the record.
    #
    # @raise [Spire::Error] if the order could not be updated.
    #
    # @return [String] The JSON representation of the updated order returned by
    # the Spire API.
    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]] }]

      clear_changes

      client.put("/sales/orders/#{id}", payload)
    end

    # Delete this order
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/sales/orders/#{id}")
    end

    # Invoice the order
    #
    # @return [String] the JSON response from the Spire API
    def invoice
      client.post("/sales/orders/#{id}/invoice")
    end
    

    # Sets status to on hold.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def put_on_hold
      self.hold = ON_HOLD
    end

    # Sets status to active.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_active
      self.hold = ACTIVE
    end

    # Deposited is only used for pre-paid orders IE: Credit Card/Debit
    def mark_as_deposited
      self.status = DEPOSITED
    end

    #  After order is deposited and ready to ship we can mark it as processed.
    def mark_as_processed
      self.status = PROCESSED
    end

    # Is the record valid?
    def valid?
      !items.nil? && !customer.nil?
    end
  end
end
