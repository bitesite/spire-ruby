module Spire
  # An Item is an inventory item that belongs to a primary vendor.
  #
  # @!attribute [r] id
  #   @return [int]
  # @!attribute [r] whse
  #   @return [String]
  # @!attribute [r] part_no
  #   @return [String]
  # @!attribute [rw] inventory
  #   @return [Hash]
  # @!attribute [rw] uomCode
  #   @return [String]
  # @!attribute [rw] upc
  #   @return [String]
  # @!attribute [r] createdBy
  #   @return [String]
  # @!attribute [r] modifiedBy
  #   @return [String]
  # @!attribute [r] created
  #   @return [String]
  # @!attribute [r] modified
  #   @return [String]

  class Upc < BasicData
    register_attributes :id, :whse, :part_no, :inventory, :uom_code, :upc, :created_by, :modified_by, :created, :modified,
      readonly: [
        :id, :whse, :part_no, :created_by, :modified_by, :created, :modified,
      ]

    validates_presence_of :upc, :uomCode, :inventory

    SYMBOL_TO_STRING = {
      id: "id",
      whse: "whse",
      part_no: "partNo",
      inventory: "inventory",
      uom_code: "uomCode",
      upc: "upc",
      created_by: "createdBy",
      modified_by: "modifiedBy",
      created: "created",
      modified: "modified",
    }

    class << self
      # Find a specific item by its id.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Upc]
      def find(id, params = {})
        client.find("/inventory/upcs", id, params)
      end

      # Search for upcs by query. This will even return inactive upcs!
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Upc]
      def search(query)
        client.find_many(Spire::Upc, "/inventory/upcs/", { q: query })
      end

      # Find upcs and filter. This will even return inactive upcs!
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @ return [Spire::Upc]
      def filter(filter)
        client.find_many(Spire::Upc, "/inventory/upcs/", { filter: filter })
      end

      # Create a new item and save it on Spire.
      #
      # @param [Hash] options
      # @option options [String] :upc The UPC number
      # @option options [String] :uomCode The unit that of the Spire item that the UPC should be linked to
      # @option options [Hash] :inventory The Spire item that the UPC should be linked to {id: ""}
      #
      # @raise [Spire::Error] if the item could not be created.
      #
      # @return [Spire::Upc]
      def create(options)
        client.create(:upc,
                      "upc" => options[:upc],
                      "uomCode" => options[:uom_code],
                      "inventory" => options[:inventory])
      end
    end

    # Update the fields of an item.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # an item.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    # @param [Hash] fields
    # @field fields [String] :upc The UPC number
    # @field fields [String] :uomCode The unit that of the Spire item that the UPC should be linked to
    # @field fields [Hash] :inventory The Spire item that the UPC should be linked to {id: "", whse: ""}
    #
    # @return [Spire::Upc] self
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
        upc: upc,
        uomCode: uom_code,
        inventory: inventory,
      }

      from_response client.post("/inventory/upcs/", options)
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

      client.put("/inventory/upcs/#{id}", payload)
    end

    # Delete this item
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/inventory/upcs/#{id}")
    end

    # Is the record valid?
    def valid?
      !uom_code.nil? && !inventory.nil? && !upc.nil?
    end
  end
end
