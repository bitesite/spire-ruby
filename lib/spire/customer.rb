module Spire
  # A Customer is a customer account.
  #
  # @!attribute [r] id
  #   @return [int]
  # @!attribute [rw] name
  #   @return [String]
 
  class Customer < BasicData
    register_attributes :name,
      readonly: [
        :id
      ]

    validates_presence_of :id, :name

    SYMBOL_TO_STRING = {
      id: 'id',
      name: 'name'
    }

    ACTIVE = 'A'
    INACTIVE = 'I'

    class << self
      # Find a specific customer by its id.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Customer]
      def find(id, params = {})
        client.find('/customers/', id, params)
      end

      # Search for customers by query. This will even return inactive customers!
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Customer]
      def search(query)
        client.find_many(Spire::Customer, '/customers/', {q: query})
      end

      # Create a new customer and save it on Spire.
      #
      # @param [Hash] options
      # @option options [String] :name The name of the customer
      #
      # @raise [Spire::Error] if the item could not be created.
      #
      # @return [Spire::Customer]
      def create(options)
        client.create(:customer,
          'name' => options[:name]
        )
      end
    end

    # Update the fields of a customer.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # a customer.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    # @param [Hash] fields
    # @option fields [String] :name The name of the customer
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
        name: name
      }

      from_response client.post("/customers/", options)
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

      client.put("/customers/#{id}", payload)
    end

    # Delete this item
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/customers/#{id}")
    end

    # Sets status to inactive.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_inactive
      self.status = INACTIVE
    end

    # Sets status to active.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_active
      self.status = ACTIVE
    end

    # Is the record valid?
    def valid?
      !name.nil?
    end
  end
end