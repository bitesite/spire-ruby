module Spire
  # A Currency is a type of currency.
 
  class Currency < BasicData
    register_attributes :id, :code, :country, :description, :indirect, :fixed_rate, :buy_rate,
                        :sell_rate, :last_year_rate, :this_year_rate, :next_year_rate, :symbol,
      readonly: [
        :id
      ]

    validates_presence_of :id

    SYMBOL_TO_STRING = {
      id: 'id',
      code: 'code',
      country: 'country',
      description: 'description',
      indirect: 'indirect',
      fixed_rate: 'fixedRate',
      buy_rate: 'buyRate',
      sell_rate: 'sellRate',
      last_year_rate: 'lastYearRate',
      this_year_rate: 'thisYearRate',
      next_year_rate: 'nextYearRate',
      symbol: 'symbol'
    }

    class << self
      # Find a specific currency by its id.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Currency]
      def find(id, params = {})
        client.find('/currencies', id, params)
      end

      # Search for currencies by query.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Currency]
      def search(query)
        client.find_many(Spire::Currency, '/currencies/', {q: query})
      end

      # Create a new currency and save it on Spire.
      #
      # @param [Hash] options
      # @option options [String] :name The name of the currency
      #
      # @raise [Spire::Error] if the item could not be created.
      #
      # @return [Spire::Currency]
      def create(options)
        client.create(:currency,
          'id' => options[:id],
          'code' => options[:code],
          'country' => options[:country],
          'description' => options[:description],
          'indirect' => options[:indirect],
          'fixedRate' => options[:fixed_rate],
          'buyRate' => options[:buy_rate],
          'sellRate' => options[:sell_rate],
          'lastYearRate' => options[:last_year_rate],
          'thisYearRate' => options[:this_year_rate],
          'nextYearRate' => options[:next_year_rate],
          'symbol' => options[:symbol]
        )
      end
    end

    # Update the fields of a currency.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # a currency.
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
        id: id, 
        code: code, 
        country: country, 
        description: description, 
        indirect: indirect, 
        fixedRate: fixed_rate, 
        buyRate: buy_rate, 
        sellRate: sell_rate, 
        lastYearRate: last_year_rate, 
        thisYearRate: this_year_rate, 
        nextYearRate: next_year_rate, 
        symbol: symbol
      }

      from_response client.post("/currencies/", options)
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

      client.put("/currencies/#{id}", payload)
    end

    # Delete this item
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/currencies/#{id}")
    end

    # Is the record valid?
    def valid?
      !name.nil?
    end
  end
end