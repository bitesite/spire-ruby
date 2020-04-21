module Spire
  # An Order is a record that belongs to a Customer
  #
  # @!attribute [r] id
  #   @return [int]
  # @!attribute [r] invoice_no
  #   @return [String]
  # @!attribute [r] order_no
  #   @return [String]
  # @!attribute [r] created
  #   @return [String]
  # @!attribute [r] modified
  #   @return [String]
  # @!attribute [r] created_by
  #   @return [String]
  # @!attribute [r] modified_by
  #   @return [String]
  class Invoice < BasicData
    register_attributes :id, :invoice_no, :order_no, 
      :created_by, :modified_by, :created, :modified,
      readonly: [
        :id, :invoice_no, :order_no,
        :created_by, :modified_by, :created, :modified
      ]

    validates_presence_of :id

    SYMBOL_TO_STRING = {
      id: "id",
      invoice_no: "invoiceNo",
      order_no: "orderNo",
      created_by: "createdBy",
      modified_by: "modifiedBy",
      created: "created",
    }

    class << self
      # Find a specific invoice by its id.
      #
      # @raise [Spire::Error] if the invoice could not be found.
      #
      # @return [Spire::Invoice]
      def find(id, params = {})
        client.find("/sales/invoices", id, params)
      end

      # Search for invoice by query.
      #
      # @raise [Spire::Error] if the invoice could not be found.
      #
      # @return [Spire::Invoice]
      def search(query)
        client.find_many(Spire::Invoice, "/sales/invoices/", { q: query })
      end
    end

    # Update the fields of an invoice.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing an invoice.
    #
    # Note that this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    # @param [Hash] fields
    # @option fields [Hash] :id
    # @option fields [String] :invoice_no
    # @option fields [String] :order_no
    # @option fields [String] :created_by
    # @option fields [String] :modified_by
    # @option fields [String] :created
    # @option fields [String] :modified

    def update_fields(fields)
      # instead of going through each attribute on self, iterate through each item in field and update from there
      self.attributes.each do |k, v|
        attributes[k.to_sym] = fields[SYMBOL_TO_STRING[k.to_sym]] || fields[k.to_sym] || attributes[k.to_sym]
      end

      attributes[:id] = fields[SYMBOL_TO_STRING[:id]] || attributes[:id]
      self
    end

  end
end
