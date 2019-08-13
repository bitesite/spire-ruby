module Spire
  # A SalesPerson is a person.
  
 
  class Salesperson < BasicData
    register_attributes :id, :sales_person_no, :code, :name, :created, :created_by, :modified, :modified_by,
    readonly: [
        :id, :created_by, :modified_by
      ]

    validates_presence_of :id, :name

    SYMBOL_TO_STRING = {
      id: 'id',
      sales_person_no: 'salespersonNo',
      code: 'code',
      name: 'name',
      created: 'created',
      created_by: 'createdBy',
      modified: 'modified',
      modified_by: 'modifiedBy'
    }

    class << self
      # Find a specific sales person by its id.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::SalesPeople]
      def find(id, params = {})
        client.find('/salespeople', id, params)
      end

      # Search for sales people by query.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::SalesPeople]
      def search(query)
        client.find_many(Spire::Salesperson, '/salespeople/', {q: query})
      end

      # Search for all sales people
      #
      # @raise [Spire::Error] if the items could not be found.
      #
      # @return [Spire::Salesperson]
      def all(limit)
        client.get('/salespeople/', {limit: limit})
      end

      # Create a new sales person and save it on Spire.
      #
      # @param [Hash] options
      # @option options [String] :name The name of the sales person
      #
      # @raise [Spire::Error] if the item could not be created.
      #
      # @return [Spire::SalesPeople]
      def create(options)
        client.create(:salespeople,
          'id' => options[:id],
          'salespersonNo' => options[:sales_person_no],
          'code' => options[:code],
          'name' => options[:name],
          'created' => options[:created],
          'createdBy' => options[:created_by],
          'modified' => options[:modified],
          'modifiedBy' => options[:modified_by]
        )
      end
    end

    # Update the fields of a sales person.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # a sales person.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    # @param [Hash] fields
    # @option fields [String] :name The name of the sales person
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
        sales_person_no: salespersonNo,
        code: code,
        name: name,
        created: created,
        created_by: createdBy,
        modified: modified,
        modified_by: modifiedBy
      }

      from_response client.post("/salespeople/", options)
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

      client.put("/salespeople/#{id}", payload)
    end

    # Delete this item
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/salespeople/#{id}")
    end

    # Is the record valid?
    def valid?
      !name.nil?
    end
  end
end