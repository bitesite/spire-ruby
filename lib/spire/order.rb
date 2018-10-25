module Spire
  # A Customer is a customer account.
  #
  # @!attribute [r] id
  #   @return [int]
  # @!attribute [rw] background_color As a color decimal
  #   @return [int]

  # @!attribute [rw] customer
  #   @return [Hash]
  # @!attribute [rw] address 
  #   @return [Hash]
  # @!attribute [rw] shipping_address
  #   @return [Hash]
  # @!attribute [rw] items
  #   @return [Array]

  class Order < BasicData
    register_attributes :id, :background_color, :customer, :address, :shippingAddress, :items, :created_by, :modified_by,
      readonly: [
        :id
      ]

    validates_presence_of :customer, :items

    SYMBOL_TO_STRING = {
      id: 'id',
      background_color: 'backgroundColor', 
      customer: 'customer',
      address: 'address',
      shipping_address: "shippingAddress",
      items: 'items',
      created_by: 'createdBy',
      modified_by: 'modifiedBy'
    }

    class << self
      # Find a specific order by its id
      #
      # @raise [Spire::Error] if the order could not be found.
      #
      # @return [Spire::Order]
      def find(id)
        client.find('/sales/orders', id)
      end

      # Search for orders by query.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Order]
      def search(query)
        client.find_many(Spire::Order, '/sales/orders/', {q: query})
      end

      # Create a new order and save it on Spire.
      #
      # @param [Hash] options
      #
      # @raise [Spire::Error] if the item could not be created.
      #
      # @return [Spire::Order]
      def create(options)
        client.create('/sales/orders',
          'backgroundColor' => options[:background_color],
          'customer' => options[:customer],
          'address' => options[:address],
          'shippingAddress' => options[:shipping_address],
          'items' => options[:items]
        )
      end
    end

    # Saves a record.
    #
    # @raise [Spire::Error] if the item could not be saved
    #
    # @return [String] The JSON representation of the saved item returned by
    #     the Spire API.
    def save
      # If we have an id, just update our fields.
      return update! if id

      options = {
        customer: customer || {},
        items: items || [],
        address: address || {},
        shippingAddress: shippingAddress || {},
        backgroundColor: background_color || 16777215,
        createdBy: created_by || '',
        modifiedBy: modified_by || ''
      }

      from_response client.post("/sales/orders/", options)
    end

    # Update an existing record.
    #
    # Warning: this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh!
    # this object before making your changes, and before updating the record.
    #
    # @raise [Spire::Error] if the item could not be updated.
    #
    # @return [String] The JSON representation of the updated item returned by
    #     the Spire API.
    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]] }]
      @changed_attributes.clear

      client.put("/sales/orders/#{id}", payload)
    end

    # Update the fields of a order.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # a order.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    # @param [Hash] fields
    #
    # @return [Spire::Item] self
    def update_fields(fields)

      # instead of going through each attribute on self, iterate through each item in field and update from there
      self.attributes.each do |k, v|
        attributes[k.to_sym] = fields[SYMBOL_TO_STRING[k.to_sym]] || fields[k.to_sym] || attributes[k.to_sym]
      end

      attributes[:id] = fields[SYMBOL_TO_STRING[:id]] || attributes[:id]
      self
    end

    # Delete this item
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/sales/orders/#{id}")
    end
  end
end