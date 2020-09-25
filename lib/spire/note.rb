module Spire
  # A Note that can be attached to various resources
  #
  # @!attribute [r] id
  #   @return [int]
  # @!attribute [rw] link_table
  #   @return [String]
  # @!attribute [rw] link_no
  #   @return [String]
  # @!attribute [rw] subject
  #   @return [String]
  # @!attribute [rw] body
  #   @return [String]
  # @!attribute [rw] alert
  #   @return [Boolean]
  # @!attribute [r] created_by
  #   @return [String]
  # @!attribute [r] last_modified
  #   @return [String]
  # @!attribute [r] modified_by
  #   @return [String]
  # @!attribute [r] created
  #   @return [String]
  # @!attribute [r] modified
  #   @return [String]

  class Note < BasicData
    register_attributes :id, 
                        :link_table,
                        :link_no,
                        :subject,
                        :body,
                        :alert,
                        :created_by,
                        :last_modified,
                        :modified_by,
                        :created,
                        :modified,
                        readonly: [
                          :last_modified, 
                          :modified_by, 
                          :created_by,
                          :created, 
                          :modified,
                        ]

    validates_presence_of :link_table, :link_no
    
    # link_table codes
    ACCOUNTS_PAYABLE_TABLE_LINK_CODE = "AP"
    ACCOUNTS_RECEIVABLE_TABLE_LINK_CODE = "AR"
    PRODUCTION_ORDERS_TABLE_LINK_CODE = "BORD"
    CUSTOMER_TABLE_LINK_CODE = "CUST"
    EMPLOYEE_TABLE_LINK_CODE = "EMP"
    INVENTORY_ADJUSTMENT_TABLE_LINK_CODE = "IADJ"
    INVENTORY_TABLE_LINK_CODE = "INV"
    JOB_COST_TABLE_LINK_CODE = "JC"
    COMMUNICATION_TABLE_LINK_CODE = "NOTE"
    PURCHASE_ORDER_TABLE_LINK_CODE = "PORD"
    SALES_ORDER_TABLE_LINK_CODE = "SORD"
    GENERAL_LEDGER_TRANSACTION_TABLE_LINK_CODE = "TRAN"
    VENDOR_TABLE_LINK_CODE = "VEND"

    SYMBOL_TO_STRING = {
      id: "id",
      link_table: "linkTable",
      link_no: "linkNo",
      subject: "subject",
      body: "body",
      alert: "alert",
      created_by: "createdBy",
      last_modified: "lastModified",
      modified_by: "modifiedBy",
      created: "created",
      modified: "modified",
    }

    ROOT_PATH = "/crm/notes"

    class << self
      # Create a note for a Sales Order
      #
      # @param [String] order_no - Note this is the Spire Order Number and NOT the Spire Order ID
      #
      # @return [Spire::Note]
      def new_for_sales_order(order_no)
        Note.new(link_table: SALES_ORDER_TABLE_LINK_CODE, link_no: order_no)
      end

      # Find a specific note by its id.
      #
      # @raise [Spire::Error] if the note could not be found.
      #
      # @return [Spire::Note]
      def find(id, params = {})
        client.find(ROOT_PATH, id, params)
      end

      # Search for notes by query.
      #
      # @raise [Spire::Error] if the note could not be found.
      #
      # @return [Spire::Note]
      def search(query, limit = nil)

        options = { q: query }
        options[:limit] = limit if limit

        client.find_many(Spire::Note, ROOT_PATH, options)
      end

      # Find notes through a filter.
      #
      # @raise [Spire::Error] if the note could not be found.
      #
      # @ return [Spire::Note]
      def filter(filter)
        client.find_many(Spire::Note, ROOT_PATH, { filter: filter })
      end

      # Create a new item and save it on Spire.
      #
      # @param [Hash] options
      #
      # @raise [Spire::Error] if the note could not be created.
      #
      # @return [Spire::Note]
      def create(options)
        client.create(:note,
                      "linkTable" => options[:link_table],
                      "linkNo" => options[:link_no],
                      "subject" => options[:subject],
                      "body" => options[:body],
                      "alert" => options[:alert],
                      "createdBy" => options[:created_by]
                      )
      end
    end

    # Update the fields of a note.
    #
    # Supply a hash of string keyed data retrieved from the Spire API representing
    # a note.
    #
    # Note that this this method does not save anything new to the Spire API,
    # it just assigns the input attributes to your local object. If you use
    # this method to assign attributes, call `save` or `update!` afterwards if
    # you want to persist your changes to Spire.
    #
    # @param [Hash] fields
    #
    # @return [Spire::Note] self
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
    # @raise [Spire::Error] if the note could not be saved
    #
    # @return [String] The JSON representation of the saved note returned by
    #     the Spire API.
    def save
      # If we have an id, just update our fields.
      return update! if id

      payload = {
        linkTable: link_table,
        linkNo: link_no,
        subject: subject,
        body: body,
        alert: alert || false,
      }

      from_response client.post(ROOT_PATH, payload)
    end

    # Update an existing record.
    #
    # Warning: this updates all fields using values already in memory. If
    # an external resource has updated these fields, you should refresh!
    # this object before making your changes, and before updating the record.
    #
    # @raise [Spire::Error] if the note could not be updated.
    #
    # @return [String] The JSON representation of the updated item returned by
    #     the Spire API.
    def update!
      @previously_changed = changes
      # extract only new values to build payload
      payload = Hash[changes.map { |key, values| [SYMBOL_TO_STRING[key.to_sym].to_sym, values[1]] }]

      clear_changes

      client.put("#{ROOT_PATH}/#{id}", payload)
    end

    # Delete this item
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("${ROOT_PATH}/#{id}")
    end

    # Is the record valid?
    def valid?
      !link_table.nil? && !link_no.nil?
    end
  end
end
