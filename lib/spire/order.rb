module Spire
  # An Order is a record that belongs to a Customer
  #
  # @!attribute [r] id
  #   @return [int]
  # @!attribute [r] order_no
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

  class Order < BasicData
    register_attributes :id, :order_no, :customer, :status, :type, :hold,
      :order_date, :address, :shipping_address, :customer_po, :fob, :terms_code,
      :terms_text, :freight, :taxes, :subtotal, :subtotal_ordered, :discount,
      :total_discount, :total, :total_ordered, :gross_profit, :items, :created_by,
      :modified_by, :created, :modified, :background_color,
      readonly: [
        :created_by, :modified_by, :created, :modified, :order_no
      ]

    validates_acceptance_of :id, :customer, :address, :shipping_address, :items

    ACTIVE = "0"
    ON_HOLD = "1"
    INACTIVE = "2"

    SYMBOL_TO_STRING = {
      id: 'id',
      order_no: 'orderNo',
      customer: 'customer',
      status: 'status',
      type: 'type',
      hold: 'hold',
      order_date: 'orderDate',
      address: 'address',
      shipping_address: 'shippingAddress',
      customer_po: 'shippingPO',
      fob: 'fob',
      terms_code: "termsCode",
      terms_text: 'termsText',
      freight: 'freight',
      taxes: 'taxes',
      subtotal: 'subtotal',
      subtotal_ordered: 'subtotalOrdered',
      discount: 'discount',
      total_discount: 'totalDiscount',
      total: 'total',
      total_ordered: 'totalOrdered',
      gross_profit: 'grossProfit',
      items: 'items',
      created_by: 'createdBy',
      modified_by: 'modifiedBy',
      created: 'created',
      modified: 'modified',
      background_color: 'backgroundColor'
    }

    class << self
       # Find a specific order by its id.
      #
      # @raise [Spire::Error] if the order could not be found.
      #
      # @return [Spire::Order]

      def find(id, params = {})
        client.find('/sales/orders', id, params)
      end

      # Search for order by query. This will even return inactive orders!
      #
      # @raise [Spire::Error] if the order could not be found.
      #
      # @return [Spire::Order]

      def search(query)
        client.find_many(Spire::Order, '/sales/orders/', {q: query})
      end

      # Create a new item and save it on Spire.
      #
      # @param [Hash] options
      # @option options [Hash] :customer the spire customer who will be associated with the order
      # @option options [Hash] :address this is the billing address for the customer
      # @option options [Hash] :shipping_address this is the shipping address that the order will be sent to (defaults to the billing address if none provided)
      # @option options [Array] :items this is an array of hashes that will accept an inventory item that will have a hash example input from the web client: items: [ { "inventory": {"id": 123} } ]
      # this array can also accept a desctiption and comment object that will create a comment on the order itself ex: items: [{"description":"MAKE COMMENT THRU API","comment":"MAKE COMMENT THRU API"}]

      # @raise [Spire::Error] if the order could not be created.
      #
      # @return [Spire::Order]

      def create(options)
        client.create(
          :order,
          'customer' => options[:customer],
          'address' => options[:address],
          'shippingAddress' => options[:shipping_address],
          'items' => options[:items],
          'discount' => options[:discount]
        )
      end
    end

    # Update the fields of an order.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing an order.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    #@param [Hash] fields
    # @option fields [Hash] :customer The customer object that we will pass to spire
    # @option fields [String] :status
    # @option fields [String] :type
    # @option fields [Boolean] :hold
    # @option fields [String] :order_date
    # @option fields [Hash] :address This is the Billing Address for the customer
    # @option fields [Hash] :shipping_address This is the shipping address, if none provided it will default to the billing address
    # @option fields [String] :customer_po
    # @option fields [String] :fob
    # @option fields [String] :terms_code
    # @option fields [String] :terms_text
    # @option fields [String] :freight
    # @option fields [Array] :taxes
    # @option fields [String] :subototal
    # @option fields [String] :subtotal_ordered
    # @option fields [String] :discount
    # @option fields [String] :total_discount
    # @option fields [String] :total
    # @option fields [String] :total_ordered
    # @option fields [String] :gross_profit
    # @option fields [Array] :items This will be an array of hashes, where if inventory is null and a comment option is provided, it will create a "Comment" on the order instead of a line item
    # @option fields [String] :background_color - the sync color that we use in spire




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
        customer: customer|| {},
        address: address || {},
        shippingAddress: shipping_address || {},
        items: items || {},
        discount: discount || "0",
        backgroundColor: background_color || 16777215
      }

      from_response client.post("/sales/orders/", options)
    end

    # Update an existing record.
    #
    # Warning: this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh wuth update fields mehtod!
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
      @changed_attributes.clear

      client.put("/sales/orders/#{id}", payload)
    end

    # Delete this order
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/sales/orders/#{id}")
    end

    # Sets status to inactive.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_inactive
      self.status = INACTIVE
    end

    # Sets status to on hold.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def put_on_hold
      self.status = ON_HOLD
    end

    # Sets status to active.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_active
      self.status = ACTIVE
    end

    # Is the record valid?
    def valid?
      !order_no.nil? && !items.nil? && !customer.nil?
    end
  end
end