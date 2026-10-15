module Spire
  module AR
    # An accounts receivable Transaction (invoice, payment, credit or debit) on a Customer's account.
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [rw] customer
    #   @return [Hash] eg: { "id" => 214, "code" => "A1PAR", "customerNo" => "A1PAR" }
    # @!attribute [rw] date
    #   @return [String]
    # @!attribute [rw] trans_type
    #   @return [String] one of INVOICE, PAYMENT, CREDIT or DEBIT
    # @!attribute [r] trans_no
    #   @return [String]
    # @!attribute [r] ref_no
    #   @return [String]
    # @!attribute [rw] reference_no
    #   @return [String]
    # @!attribute [rw] customer_po
    #   @return [String]
    # @!attribute [rw] debit_amt
    #   @return [String]
    # @!attribute [rw] credit_amt
    #   @return [String]
    # @!attribute [r] balance
    #   @return [String]
    # @!attribute [rw] payment_method
    #   @return [int]
    # @!attribute [rw] memo
    #   @return [String]
    class Transaction < BasicData
      register_attributes :id, :date, :link_date, :trans_type, :trans_no, :ref_no,
        :debit_amt, :credit_amt, :base_debit_amt, :base_credit_amt, :balance, :link_balance,
        :user, :terms_code, :due_date, :reference_no, :customer_po, :memo, :customer,
        :payment_method, :freight, :taxes, :total,
        :created, :created_by, :modified, :modified_by,
        readonly: [
          :id, :link_date, :trans_no, :ref_no, :base_debit_amt, :base_credit_amt, :balance, :link_balance,
          :user, :due_date, :created, :created_by, :modified, :modified_by,
        ]

      validates_presence_of :customer, :trans_type

      # trans_type codes
      CREDIT = "C"
      DEBIT = "D"
      INVOICE = "I"
      PAYMENT = "P"

      SYMBOL_TO_STRING = {
        id: "id",
        date: "date",
        link_date: "linkDate",
        trans_type: "transType",
        trans_no: "transNo",
        ref_no: "refNo",
        debit_amt: "debitAmt",
        credit_amt: "creditAmt",
        base_debit_amt: "baseDebitAmt",
        base_credit_amt: "baseCreditAmt",
        balance: "balance",
        link_balance: "linkBalance",
        user: "user",
        terms_code: "termsCode",
        due_date: "dueDate",
        reference_no: "referenceNo",
        customer_po: "customerPO",
        memo: "memo",
        customer: "customer",
        payment_method: "paymentMethod",
        freight: "freight",
        taxes: "taxes",
        total: "total",
        created: "created",
        created_by: "createdBy",
        modified: "modified",
        modified_by: "modifiedBy",
      }

      class << self
        # Find a specific AR transaction by its id.
        #
        # @raise [Spire::Error] if the transaction could not be found.
        #
        # @return [Spire::AR::Transaction]
        def find(id, params = {})
          client.find("/ar/transactions", id, params)
        end

        # Search for AR transactions by query.
        #
        # @raise [Spire::Error] if the transactions could not be found.
        #
        # @return [Array<Spire::AR::Transaction>]
        def search(query)
          client.find_many(Spire::AR::Transaction, "/ar/transactions/", { q: query })
        end

        # Find AR transactions with the given params (eg: filter, limit).
        #
        # Example (an invoice's number is stored in refNo; transNo is the AR ledger sequence number):
        #   Spire::AR::Transaction.find_many(filter: { transType: "I", refNo: "0000123" }.to_json)
        #
        # @return [Array<Spire::AR::Transaction>]
        def find_many(params = {})
          client.find_many(Spire::AR::Transaction, "/ar/transactions/", params)
        end

        # Create a new AR transaction and save it on Spire.
        #
        # @param [Hash] options
        # @option options [Hash] :customer must include the customer "id"
        # @option options [String] :trans_type one of INVOICE, PAYMENT, CREDIT or DEBIT
        # @option options [String] :credit_amt required for payments and credits
        # @option options [String] :debit_amt required for invoices and debits
        # @option options [int] :payment_method the Spire payment method id
        # @option options [String] :date eg: "2026-10-09"
        # @option options [String] :reference_no
        # @option options [String] :memo
        #
        # @raise [Spire::Error] if the transaction could not be created.
        #
        # @return [Spire::AR::Transaction] with only the id populated
        def create(options)
          client.create("/ar/transactions", options)
        end
      end

      # Update the fields of an AR transaction.
      #
      # Supply a hash of string keyed data retrieved from the Spire API representing an AR transaction.
      #
      # Note that this method does not save anything new to the Spire API,
      # it just assigns the input attributes to your local object.
      #
      # @param [Hash] fields
      #
      # @return [Spire::AR::Transaction] self
      def update_fields(fields)
        # instead of going through each attribute on self, iterate through each item in field and update from there
        self.attributes.each do |k, v|
          attributes[k.to_sym] = fields[SYMBOL_TO_STRING[k.to_sym]] || fields[k.to_sym] || attributes[k.to_sym]
        end

        attributes[:id] = fields[SYMBOL_TO_STRING[:id]] || attributes[:id]
        self
      end

      # Creates the transaction on Spire.
      #
      # AR transactions cannot be updated once posted, so this only supports new records.
      #
      # @raise [Spire::Error] if the transaction already exists or could not be created.
      #
      # @return [Spire::AR::Transaction] self, with the id assigned by Spire
      def save
        raise Spire::Error, "AR transaction #{id} already exists and cannot be updated." if id

        options = {
          customer: customer,
          date: date,
          transType: trans_type,
          referenceNo: reference_no,
          customerPO: customer_po,
          debitAmt: debit_amt,
          creditAmt: credit_amt,
          termsCode: terms_code,
          paymentMethod: payment_method,
          freight: freight,
          taxes: taxes,
          total: total,
          memo: memo,
        }.reject { |_key, value| value.nil? }

        from_response client.post("/ar/transactions/", options)
      end

      # Apply this transaction (eg: a payment or credit) against another transaction (eg: an invoice).
      #
      # @param [int] apply_transaction_id the id of the AR transaction to apply against
      # @param [Numeric, String] amount the amount to apply. Applies the full amount when nil.
      #
      # @raise [Spire::Error] if the transaction could not be applied.
      #
      # @return [String] the JSON response from the Spire API
      def apply(apply_transaction_id, amount = nil)
        path = "/ar/transactions/#{id}/apply/#{apply_transaction_id}"
        path += "?#{URI.encode_www_form(amount: amount)}" if !amount.nil?

        client.post(path)
      end

      def invoice?
        trans_type == INVOICE
      end

      def payment?
        trans_type == PAYMENT
      end
    end
  end
end
