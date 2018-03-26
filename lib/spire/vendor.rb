module Spire
  # A Vendor sells many inventor items.
  #
  # @!attribute [r] id
  #   @return [int]
  # @!attribute [rw] vendorNo
  #   @return [String]
  # @!attribute [rw] code
  #   @return [String]
  # @!attribute [rw] name
  #   @return [String]
  # @!attribute [rw] hold
  #   @return [boolean]
  # @!attribute [rw] status
  #   @return [String]
  # @!attribute [rw] address
  #   @return [Hash]
  # @!attribute [rw] shippingAddresses
  #   @return [Array]
  # @!attribute [rw] paymentTerms
  #   @return [Hash]
  # @!attribute [rw] currency
  #   @return [String]
  # @!attribute [rw] foregroundColor
  #   @return [int]
  # @!attribute [rw] backgroundColor
  #   @return [int]
  # @!attribute [r] createdBy
  #   @return [String]
  # @!attribute [r] modifiedBy
  #   @return [String]
  # @!attribute [r] created
  #   @return [DateTime]
  # @!attribute [r] modified
  #   @return [DateTime]
  # @!attribute [r] createdDateTime
  #   @return [DateTime]
  # @!attribute [r] modifiedDateTime
  #   @return [DateTime]
  class Vendor < BasicData
    register_attributes :id, :vendor_no, :code, :name, :hold, :status, :address,
      :shipping_addresses, :payment_terms, :currency, :foreground_color,
      :background_color, :created_by, :modified_by, :created, :modified,
      :created_date_time, :modified_date_time,
      readonly: [
        :created_by,
        :modified_by,
        :created,
        :modified,
        :created_date_time,
        :modified_date_time
      ]

    validates_presence_of :id, :vendor_no, :address

    include HasActions

    SYMBOL_TO_STRING = {
      id: 'id',
      vendor_no: 'vendorNo',
      code: 'code',
      name: 'name',
      hold: 'hold',
      status: 'status',
      address: 'address',
      shipping_addresses: 'streetAddress',
      payment_terms: 'paymentTerms',
      currency: 'currency',
      foreground_color: 'foregroundColor',
      background_color: 'backgroundColor',
      created_by: 'createdBy',
      modified_by: 'modifiedBy',
      created: 'created',
      modified: 'modified',
      created_date_time: 'createdDateTime',
      modified_date_time: 'modifiedDateTime'
    }

    class << self
      # Find a specific vendor by its id.
      #
      # @raise [Spire::Error] if the vendor could not be found.
      #
      # @return [Spire::Vendor]
      def find(id, params = {})
        client.find('/vendors', id, params)
      end

      # Search for vendors by query.
      #
      # @raise [Spire::Error] if the vendor could not be found.
      #
      # @return [Spire::Vendor]
      def search(query)
        client.find_many(Spire::Vendor, '/vendors/', {q: query})
      end

      # Create a new vendor and save it on Spire.
      #
      # @param [Hash] options
      # @option options [int] :id
      # @option options [String] :vendor_no
      # @option options [String] :code
      # @option options [String] :name
      # @option options [boolean] :hold
      # @option options [String] :status
      # @option options [Hash] :address
      # @option options [Array] :shipping_addresses
      # @option options [Hash] :payment_terms
      # @option options [String] :currency
      # @option options [int] :foreground_color
      # @option options [int] :background_color
      # @option options [String] :created_by
      # @option options [String] :modified_by
      # @option options [DateTime] :created
      # @option options [DateTime] :modified
      # @option options [DateTime] :created_date_time
      # @option options [DateTime] :modified_date_time
      #
      # @raise [Spire::Error] if the vendor could not be created.
      #
      # @return [Spire::Vendor]
      def create(options)
        client.create(:vendor,
          'id' => options[:id],
          'vendorNo' => options[:vendor_no],
          'code' => options[:code],
          'name' => options[:name],
          'hold' => options[:hold],
          'status' => options[:status],
          'address' => options[:address],
          'streetAddress' => options[:shipping_addresses],
          'paymentTerms' => options[:payment_terms],
          'currency' => options[:currency],
          'foregroundColor' => options[:foreground_color],
          'backgroundColor' => options[:background_color],
          'createdBy' => options[:created_by],
          'modifiedBy' => options[:modified_by],
          'created' => options[:created],
          'modified' => options[:modified],
          'createdDateTime' => options[:created_date_time],
          'modifiedDateTime' => options[:modified_date_time]
        )
      end
    end

    # Update the fields of a vendor.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # a vendor.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    # @param [Hash] fields
    # @option fields [int] :id
    # @option fields [String] :vendor_no
    # @option fields [String] :code
    # @option fields [String] :name
    # @option fields [boolean] :hold
    # @option fields [String] :status
    # @option fields [Hash] :address
    # @option fields [Array] :shipping_addresses
    # @option fields [Hash] :payment_terms
    # @option fields [String] :currency
    # @option fields [int] :foreground_color
    # @option fields [int] :background_color
    # @option fields [String] :created_by
    # @option fields [String] :modified_by
    # @option fields [DateTime] :created
    # @option fields [DateTime] :modified
    # @option fields [DateTime] :created_date_time
    # @option fields [DateTime] :modified_date_time
    #
    # @return [Spire::Vendor] self
    def update_fields(fields)

      # Also consider extracting this common code between vendor and item to basic_data
      # instead of going through each attribute on self, iterate through each item in field and update from there
      self.attributes.each do |k, v|
        attributes[k.to_sym] = fields[SYMBOL_TO_STRING[k.to_sym]] || fields[k.to_sym] || attributes[k.to_sym]
      end

      attributes[:id] = fields[SYMBOL_TO_STRING[:id]] || attributes[:id]
      self
    end

    # Saves a record.
    #
    # @raise [Spire::Error] if the vendor could not be saved
    #
    # @return [String] The JSON representation of the saved vendor returned by
    #     the Spire API.
    def save
      # If we have an id, just update our fields.
      return update! if id

      from_response client.post("/vendors/", {
        vendorNo: vendor_no,
        code: code,
        name: name,
        hold: hold || false,
        status: status || 'A',
        address: address || {}, # seems like address is required when creating a new vendor
        streetAddress: shipping_addresses || [],
        paymentTerms: payment_terms || { code: nil, description: nil },
        currency: currency,
        foregroundColor: foreground_color || 0,
        backgroundColor: background_color || 16777215,
        createdBy: created_by,
        modifiedBy: modified_by,
        created: created,
        modified: modified,
        createdDateTime: created_date_time,
        modifiedDateTime: modified_date_time
      })
    end

    # Update an existing record.
    #
    # Warning: this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh!
    # this object before making your changes, and before updating the record.
    #
    # @raise [Spire::Error] if the vendor could not be updated.
    #
    # @return [String] The JSON representation of the updated vendor returned by
    #     the Spire API.
    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]] }]
      @changed_attributes.clear

      client.put("/vendors/#{id}", payload)
    end

    # Delete this vendor
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/vendors/#{id}")
    end

    # Sets status to inactive.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_inactive
      self.status = 'I'
    end

    # Sets status to active.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_active
      self.status = 'A'
    end

    # Is the record valid?
    def valid?
      vendor_no
    end

    # Find the creation date
    def created_at
      @created_at ||= Time.at(id[0..7].to_i(16)) rescue nil
    end
  end
end