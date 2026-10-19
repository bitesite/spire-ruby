module Spire
  module Inventory
    # A sales department is a record that groups inventory items for accounting purposes.
    # Items reference it by id via their salesDept attribute.
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [r] code
    #   @return [String]
    # @!attribute [r] description
    #   @return [String]
    # @!attribute [r] inventory_account
    #   @return [String]
    # @!attribute [r] cost_of_sales_account
    #   @return [String]
    # @!attribute [r] revenue_account
    #   @return [String]
    class SalesDepartment < BasicData
      register_attributes :id,
                          :code,
                          :description,
                          :inventory_account,
                          :cost_of_sales_account,
                          :revenue_account,
                          readonly: [
                            :id,
                            :code,
                            :description,
                            :inventory_account,
                            :cost_of_sales_account,
                            :revenue_account,
                          ]

      SYMBOL_TO_STRING = {
        id: "id",
        code: "code",
        description: "description",
        inventory_account: "inventoryAccount",
        cost_of_sales_account: "costOfSalesAccount",
        revenue_account: "revenueAccount",
      }

      class << self
        # Find a specific sales department by its id.
        #
        # @raise [Spire::Error] if the sales department could not be found.
        #
        # @return [Spire::Inventory::SalesDepartment]
        def find(id, params = {})
          # Spire returns 404 for /inventory/sales_departments/{id}
          raise Error.new("Spire API does not currently support finding sales departments by ID", 404)
        end

        # Find many sales departments
        #
        # You can pass in options like q, limit, filter and any other
        # parameters that are supported by the Spire API
        #
        # @return [Spire::Inventory::SalesDepartment]
        def find_many(options = {})
          client.find_many(Spire::Inventory::SalesDepartment, "/inventory/sales_departments/", options)
        end

        # Search for sales departments by query
        #
        # @raise [Spire::Error] if the sales departments could not be found.
        #
        # @return [Spire::Inventory::SalesDepartment]
        def search(query)
          client.find_many(Spire::Inventory::SalesDepartment, "/inventory/sales_departments/", { q: query })
        end

        # Get all sales departments as a raw JSON string
        #
        # @raise [Spire::Error] if the sales departments could not be retrieved.
        #
        # @return [String]
        def all(limit)
          client.get("/inventory/sales_departments/", { limit: limit })
        end
      end

      # Update the fields of a sales department.
      #
      # Supply a hash of string keyed data retrieved from the Spire API representing a sales department.
      #
      # Note that this method does not save anything new to the Spire API,
      # it just assigns the input attributes to your local object.
      #
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
end
