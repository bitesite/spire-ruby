module Spire
  # A PaymentMethod is a method of payment.
 
  class PaymentMethod < BasicData
    register_attributes :id, :code, :description, :accountNo, :payment_type, :display, :sequence,
                        :created, :created_by, :modified, :modified_by,
      readonly: [
        :id, :created_by, :modified_by
      ]

    validates_presence_of :id

    SYMBOL_TO_STRING = {
      id: 'id',
      code: 'code',
      description: 'description',
      account_no: 'accountNo',
      payment_type: 'paymentType',
      display: 'display',
      sequence: 'sequence',
      created: 'created',
      created_by: 'createdBy',
      modified: 'modified',
      modified_by: 'modifiedBy'
    }

    class << self
      # Find a specific payment method by its id.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::PaymentMethod]
      def find(id, params = {})
        client.find('/payment_methods', id, params)
      end

      # Search for payment methods by query
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::PaymentMethod]
      def search(query)
        client.find_many(Spire::PaymentMethod, '/payment_methods/', {q: query})
      end

      # Create a new payment methods and save it on Spire.
      #
      # @param [Hash] options
      # @option options [String] :name The name of the payment methods
      #
      # @raise [Spire::Error] if the item could not be created.
      #
      # @return [Spire::PaymentMethod]
      def create(options)
        client.create(:payment_method,
          'id' => options[:id],
          'code' => options[:code],
          'description' => options[:description],
          'accountNo' => options[:account_no],
          'paymentType' => options[:payment_type],
          'display' => options[:display],
          'sequence' => options[:sequence],
          'created' => options[:created],
          'createdBy' => options[:created_by],
          'modified' => options[:modified],
          'modifiedBy' => options[:modified_by]
        )
      end
    end

    # Update the fields of a payment method.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # a payment method.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    # @param [Hash] fields
    # @option fields [String] :name The name of the payment method
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
        id: id,
        code: code,
        description: description,
        accountNo: account_no,
        paymentType: payment_type,
        display: display,
        sequence: sequence
      }

      from_response client.post("/payment_methods/", options)
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

      client.put("/payment_methods/#{id}", payload)
    end

    # Delete this item
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/payment_methods/#{id}")
    end

    # Is the record valid?
    def valid?
      !name.nil?
    end
  end
end