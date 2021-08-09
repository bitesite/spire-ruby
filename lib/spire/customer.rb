module Spire
  # A Customer is a customer account.
  #
  # @!attribute [r] id
  #   @return [int]
  # @!attribute [rw] name
  #   @return [String]
  # @!attribute [rw] customer_no
  #   @return [String]
  # @!attribute [rw] code
  #   @return [String]
  # @!attribute [rw] hold
  #   @return [boolean]
  # @!attribute [rw] status
  #   @return [String]
  # @!attribute [rw] reference
  #   @return [String]
  # @!attribute [rw] apply_finance_charges
  #   @return [boolean]
  # @!attribute [rw] foreground_color As a color decimal
  #   @return [int]
  # @!attribute [rw] background_color As a color decimal
  #   @return [int]
  # @!attribute [rw] credit_type
  #   @return [int]
  # @!attribute [rw] credit_balance
  #   @return [String]
  # @!attribute [rw] currency
  #   @return [String]
  # @!attribute [rw] default_ship_to
  #   @return [String]
  # @!attribute [rw] user_def_1
  #   @return [String]
  # @!attribute [rw] user_def_2
  #   @return [String]
  # @!attribute [rw] discount
  #   @return [String]
  # @!attribute [rw] receivable_account
  #   @return [String]
  # @!attribute [rw] upload
  #   @return [boolean]
  # @!attribute [rw] address
  #   @return [Hash]
  # @!attribute [rw] shipping_addresses
  #   @return [Hash]
  # @!attribute [rw] payment_terms
  #   @return [Hash]
  # @!attribute [r] created_by
  #   @return [String]
  # @!attribute [r] modified_by
  #   @return [String]

  class Customer < BasicData
    register_attributes :id, :name, :customer_no, :code, :hold, :status, :reference, :apply_finance_charges,
      :foreground_color, :background_color, :credit_type, :credit_limit, :credit_balance,
      :currency, :default_ship_to, :user_def_1, :user_def_2, :discount, :receivable_account,
      :upload, :address, :shipping_addresses, :payment_terms, :created_by, :modified_by,
      readonly: [
        :id, :created_by, :modified_by,
      ]

    validates_presence_of :id, :name

    SYMBOL_TO_STRING = {
      id: "id",
      name: "name",
      customer_no: "customerNo",
      code: "code",
      hold: "hold",
      status: "status",
      reference: "reference",
      apply_finance_charges: "applyFinanceCharges",
      foreground_color: "foregroundColor",
      background_color: "backgroundColor",
      credit_type: "creditType",
      credit_limit: "creditLimit",
      credit_balance: "creditBalance",
      currency: "currency",
      default_ship_to: "defaultShipTo",
      user_def_1: "userDef1",
      user_def_2: "userDef2",
      discount: "discount",
      receivable_account: "receivableAccount",
      upload: "upload",
      address: "address",
      shipping_addresses: "shippingAddresses",
      payment_terms: "paymentTerms",
      created_by: "createdBy",
      modified_by: "modifiedBy",
    }

    ACTIVE = "A"
    INACTIVE = "I"

    class << self
      # Find a specific customer by its id.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Customer]
      def find(id, params = {})
        client.find("/customers", id, params)
      end

      # Search for customers by query. This will even return inactive customers!
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Customer]
      def search(query)
        client.find_many(Spire::Customer, "/customers/", { q: query })
      end

      # Find customers by filter.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @ return [Spire::Customer]
      def filter(filter)
        client.find_many(Spire::Customer, "/customers/", { filter: filter })
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
                      "name" => options[:name],
                      "customerNo" => options[:customer_no],
                      "code" => options[:code],
                      "hold" => options[:hold],
                      "status" => options[:status],
                      "reference" => options[:reference],
                      "applyFinanceCharges" => options[:apply_finance_charges],
                      "foregroundColor" => options[:foreground_color],
                      "backgroundColor" => options[:background_color],
                      "creditType" => options[:credit_type],
                      "creditLimit" => options[:credit_limit],
                      "creditBalance" => options[:credit_balance],
                      "currency" => options[:currency],
                      "defaultShipTo" => options[:default_ship_to],
                      "userDef1" => options[:user_def_1],
                      "userDef2" => options[:user_def_2],
                      "discount" => options[:discount],
                      "receivableAccount" => options[:receivable_account],
                      "upload" => options[:upload],
                      "address" => options[:address],
                      "shippingAddresses" => options[:shipping_addresses],
                      "paymentTerms" => options[:payment_terms],
                      "createdBy" => options[:created_by],
                      "modifiedBy" => options[:modified_by])
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
        name: name,
        status: status || ACTIVE,
        backgroundColor: background_color || 16777215,
        address: address || {},
        createdBy: created_by || "",
        modifiedBy: modified_by,
        hold: hold || false,
        applyFinanceCharges: apply_finance_charges || false,
        foregroundColor: foreground_color || 00000000,
        creditType: credit_type || 2,
        creditLimit: credit_limit || "0",
        creditBalance: credit_balance || "0",
        currency: currency || "CAD",
        defaultShipTo: default_ship_to || "",
        receivableAccount: receivable_account || "11210",
        upload: upload || false,
        reference: reference || "",
        userDef1: user_def_1 || "",
        userDef2: user_def_2 || "",
        discount: discount || "0",
        paymentTerms: payment_terms || {},
        shippingAddresses: shipping_addresses || [],
      }

      if customer_no.present?
        options[:customerNo] = customer_no
      end

      if code.present?
        options[:code] = code
      end

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

      clear_changes

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
