module Spire
  # A PaymentTerms is a customer account.
  #

  class PaymentTerm < BasicData
    register_attributes :id, :code, :description, :days_before_due, :days_allowed, :discount_rate, :apply_discount_to_net,
      :apply_discount_to_freight, :created, :created_by, :modified, :modified_by,
      readonly: [
        :id, :created_by, :modified_by,
      ]

    validates_presence_of :id

    SYMBOL_TO_STRING = {
      id: "id",
      code: "code",
      description: "description",
      days_before_due: "daysBeforeDue",
      days_allowed: "daysAllowed",
      discount_rate: "discountRate",
      apply_discount_to_net: "applyDiscountToNet",
      apply_discount_to_freight: "applyDiscountToFreight",
      created: "created",
      created_by: "createdBy",
      modified: "modified",
      modified_by: "modifiedBy",
    }

    class << self
      # Find a specific payment term by its id.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::PaymentTerms]
      def find(id, params = {})
        client.find("/payment_terms", id, params)
      end

      # Search for payment terms by query
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::PaymentTerms]
      def search(query)
        client.find_many(Spire::PaymentTerm, "/payment_terms/", { q: query })
      end

      # Search for all payment terms
      #
      # @raise [Spire::Error] if the items could not be found.
      #
      # @return [Spire::PaymentTerm]
      def all(limit)
        client.get("/payment_terms/", { limit: limit })
      end

      # Create a new payment term and save it on Spire.
      #
      # @param [Hash] options
      #
      # @raise [Spire::Error] if the item could not be created.
      #
      # @return [Spire::PaymentTerms]
      def create(options)
        client.create(:payment_term,
                      "id" => options[:id],
                      "code" => options[:code],
                      "description" => options[:description],
                      "daysBeforeDue" => options[:days_before_due],
                      "daysAllowed" => options[:days_allowed],
                      "discountRate" => options[:discount_rate],
                      "applyDiscountToNet" => options[:apply_discount_to_net],
                      "applyDiscountToFreight" => options[:apply_discount_to_freight],
                      "created" => options[:created],
                      "createdBy" => options[:created_by],
                      "modified" => options[:modified],
                      "modifiedBy" => options[:modified_by])
      end
    end

    # Update the fields of a payment term.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # a payment term.
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
        days_before_due: daysBeforeDue,
        days_allowed: daysAllowed,
        discount_rate: discountRate,
        apply_discount_to_net: applyDiscountToNet,
        apply_discount_to_freight: applyDiscountToFreight,
      }

      from_response client.post("/payment_terms/", options)
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

      clear_changes

      client.put("/payment_terms/#{id}", payload)
    end

    # Delete this item
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/payment_terms/#{id}")
    end

    # Is the record valid?
    def valid?
      !name.nil?
    end
  end
end
