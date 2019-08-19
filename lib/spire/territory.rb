module Spire
 
  class Territory < BasicData
    register_attributes :id, :code, :name, :description, :created, :createdBy, :modified, :modifiedBy,
      readonly: [
        :id
      ]

    validates_presence_of :id

    SYMBOL_TO_STRING = {
      id: 'id',
      code: 'code',
      name: 'name',
      description: 'description',
      created: 'created',
      createdBy: 'created_by',
      modified: 'modified',
      modifiedBy: 'modified_by'
    }

    class << self

      # Search for territories by query. This will even return inactive territories!
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Territory]
      def search(query)
        client.find_many(Spire::Territory, '/territories/', {q: query})
      end

      # Search for all territories
      #
      # @raise [Spire::Error] if the items could not be found.
      #
      # @return [Spire::Territory]
      def all(limit)
        client.get('/territories/', {limit: limit})
      end

      # Create a new territory and save it on Spire.
      #
      # @param [Hash] options
      # @option options [String] :name The name of the territory
      #
      # @raise [Spire::Error] if the item could not be created.
      #
      # @return [Spire::Territory]
      def create(options)
        client.create(:territories,
          'id' => options[:id],
          'code' => options[:code],
          'name' => options[:name],
          'description' => options[:description],
          'created' => options[:created],
          'createdBy' => options[:created_by],
          'modified' => options[:modified],
          'modifiedBy' => options[:modified_by]
        )
      end
    end

    # Update the fields of a territory.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # a territory.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    # @param [Hash] fields
    # @option fields [String] :name The name of the territory
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

    # Is the record valid?
    def valid?
      !name.nil?
    end
  end
end