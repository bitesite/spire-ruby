module Spire
 
  class ShippingMethod < BasicData
    register_attributes  :id, :code, :description, :type, :threshold, :rate, :min_charge, :max_charge,
      readonly: [
        :id
      ]

    validates_presence_of :id

    SYMBOL_TO_STRING = {
      id: 'id',
      code: 'code',
      description: 'description',
      type: 'type',
      threshold: 'threshold',
      rate: 'rate',
      min_charge: 'minCharge',
      max_charge: 'maxCharge'
    }

    class << self

      # Search for shipping methods by query. This will even return inactive shipping methods!
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::ShippingMethod]
      def search(query)
        client.find_many(Spire::ShippingMethod, '/shipping_methods/', {q: query})
      end

      # Create a new shipping method and save it on Spire.
      #
      # @param [Hash] options
      # @option options [String] :name The name of the shipping method
      #
      # @raise [Spire::Error] if the item could not be created.
      #
      # @return [Spire::ShippingMethod]
      def create(options)
        client.create(:shipping_method,
          'id' => options[:id],
          'code' => options[:code],
          'description' => options[:description],
          'type' => options[:type],
          'threshold' => options[:threshold],
          'rate' => options[:rate],
          'minCharge' => options[:min_charge],
          'maxCharge' => options[:max_charge]
        )
      end
    end

    # Update the fields of a shipping method.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # a shipping method.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    # @param [Hash] fields
    # @option fields [String] :name The name of the shipping method
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