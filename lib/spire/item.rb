module Spire
  # An Item is an inventory item that belongs to a primary vendor.
  #
  # @!attribute [r] id
  #   @return [int]
  # @!attribute [rw] whse
  #   @return [String]
  # @!attribute [rw] part_no
  #   @return [String]
  # @!attribute [rw] description
  #   @return [String]
  # @!attribute [rw] type
  #   @return [String]
  # @!attribute [rw] status
  #   @return [int]
  # @!attribute [rw] lot_numbered
  #   @return [boolean]
  # @!attribute [rw] serialized
  #   @return [boolean]
  # @!attribute [rw] available_qty
  #   @return [String]
  # @!attribute [rw] on_hand_qty
  #   @return [String]
  # @!attribute [rw] committed_qty
  #   @return [String]
  # @!attribute [rw] backorder_qty
  #   @return [String]
  # @!attribute [rw] on_purchase_qty
  #   @return [String]
  # @!attribute [rw] foreground_color As a color decimal
  #   @return [int]
  # @!attribute [rw] background_color As a color decimal
  #   @return [int]
  # @!attribute [rw] primary_vendor
  #   @return [Hash]
  # @!attribute [rw] current_po_no
  #   @return [String]
  # @!attribute [rw] po_due_date
  #   @return [DateTime]
  # @!attribute [rw] reorder_point
  #   @return [String]
  # @!attribute [rw] minimum_buy_qty
  #   @return [String]
  # @!attribute [rw] current_cost
  #   @return [String]
  # @!attribute [rw] average_cost
  #   @return [String]
  # @!attribute [rw] standard_cost
  #   @return [int]
  # @!attribute [rw] buy_measure_code
  #   @return [String]
  # @!attribute [rw] stock_measure_code
  #   @return [String]
  # @!attribute [rw] sell_measure_code
  #   @return [String]
  # @!attribute [rw] alternate_part_no
  #   @return [String]
  # @!attribute [rw] accessory_whse
  #   @return [String]
  # @!attribute [rw] accessory_part_no
  #   @return [String]
  # @!attribute [rw] product_code
  #   @return [String]
  # @!attribute [rw] group_no
  #   @return [String]
  # @!attribute [rw] sales_dept
  #   @return [int]
  # @!attribute [rw] user_def1
  #   @return [String]
  # @!attribute [rw] user_def2
  #   @return [String]
  # @!attribute [rw] discountable
  #   @return [boolean]
  # @!attribute [rw] weight
  #   @return [String]
  # @!attribute [rw] pack_size
  #   @return [String]
  # @!attribute [rw] allow_back_orders
  #   @return [boolean]
  # @!attribute [rw] allow_returns
  #   @return [boolean]
  # @!attribute [rw] duty_pct
  #   @return [String]
  # @!attribute [rw] freight_pct
  #   @return [String]
  # @!attribute [rw] manufacture_country
  #   @return [String]
  # @!attribute [rw] harmonized_code
  #   @return [String]
  # @!attribute [rw] extended_description
  #   @return [String]
  # @!attribute [rw] unit_of_measures
  #   @return [Hash]
  # @!attribute [rw] pricing
  #   @return [Hash]
  # @!attribute [rw] images
  #   @return [Array]
  # @!attribute [rw] default_expiry_date
  #   @return [String]
  # @!attribute [rw] lot_consume_type
  #   @return [String]
  # @!attribute [rw] upload
  #   @return [boolean]
  # @!attribute [r] last_modified
  #   @return [DateTime]
  # @!attribute [r] created_by
  #   @return [String]
  # @!attribute [r] modified_by
  #   @return [String]
  # @!attribute [r] created
  #   @return [String]
  # @!attribute [r] modified
  #   @return [String]

  class Item < BasicData
    register_attributes :id, :whse, :part_no, :description, :type, :status,
      :lot_numbered, :serialized, :available_qty, :on_hand_qty, :committed_qty,
      :backorder_qty, :on_purchase_qty, :foreground_color, :background_color,
      :primary_vendor, :current_po_no, :po_due_date, :reorder_point, :minimum_buy_qty,
      :current_cost, :average_cost, :standard_cost, :buy_measure_code,
      :stock_measure_code, :sell_measure_code, :alternate_part_no, :accessory_whse,
      :accessory_part_no, :product_code, :group_no, :sales_dept, :user_def1,
      :user_def2, :discountable, :weight, :pack_size, :allow_back_orders,
      :allow_returns, :duty_pct, :freight_pct, :manufacture_country,
      :harmonized_code, :extended_description, :unit_of_measures, :pricing,
      :images, :default_expiry_date, :lot_consume_type, :upload, :last_modified,
      :created_by, :modified_by, :created, :modified,
      readonly: [ :last_modified, :created_by, :modified_by, :created, :modified ]

    validates_presence_of :id, :part_no, :description, :whse, :primary_vendor

    ACTIVE = 0
    ON_HOLD = 1
    INACTIVE = 2

    SYMBOL_TO_STRING = {
      id: 'id',
      whse: 'whse',
      part_no: 'partNo',
      description: 'description',
      type: 'type',
      status: 'status',
      lot_numbered: 'lotNumbered',
      serialized: 'serialized',
      available_qty: 'availableQty',
      on_hand_qty: 'onHandQty',
      committed_qty: 'committedQty',
      backorder_qty: 'backorderQty',
      on_purchase_qty: 'onPurchaseQty',
      foreground_color: 'foregroundColor',
      background_color: 'backgroundColor',
      primary_vendor: 'primaryVendor',
      current_po_no: 'currentPoNo',
      po_due_date: 'poDueDate',
      reorder_point: 'reorderPoint',
      minimum_buy_qty: 'minimumBuyQty',
      current_cost: 'currentCost',
      average_cost: 'averageCost',
      standard_cost: 'standardCost',
      buy_measure_code: 'buyMeasureCode',
      stock_measure_code: 'stockMeasureCode',
      sell_measure_code: 'sellMeasureCode',
      alternate_part_no: 'alternatePartNo',
      accessory_whse: 'accessoryWhse',
      accessory_part_no: 'accessoryPartNo',
      product_code: 'productCode',
      group_no: 'groupNo',
      sales_dept: 'salesDept',
      user_def1: 'userDef1',
      user_def2: 'userDef2',
      discountable: 'discountable',
      weight: 'weight',
      pack_size: 'packSize',
      allow_back_orders: 'allowBackorders',
      allow_returns: 'allowReturns',
      duty_pct: 'dutyPct',
      freight_pct: 'freightPct',
      manufacture_country: 'manufactureCountry',
      harmonized_code: 'harmonizedCode',
      extended_description: 'extendedDescription',
      unit_of_measures: 'unitOfMeasures',
      pricing: 'pricing',
      images: 'images',
      default_expiry_date: 'defaultExpiryDate',
      lot_consume_type: 'lotConsumeType',
      upload: 'upload',
      last_modified: 'lastModified',
      created_by: 'createdBy',
      modified_by: 'modifiedBy',
      created: 'created',
      modified: 'modified'
    }

    class << self
      # Find a specific item by its id.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Item]
      def find(id, params = {})
        client.find('/inventory/items', id, params)
      end

      # Search for items by query.
      #
      # @raise [Spire::Error] if the item could not be found.
      #
      # @return [Spire::Item]
      def search(query)
        client.find_many(Spire::Item, '/inventory/items/', {q: query})
      end

      # Create a new item and save it on Spire.
      #
      # @param [Hash] options
      # @option options [String] :whse The wharehouse where the items is located
      # @option options [String] :part_no The part number of the new item
      # @option options [String] :description The description of the new item
      # @option options [String] :type
      # @option options [int] :status
      # @option options [boolean] :lot_numbered
      # @option options [boolean] :serialized
      # @option options [String] :available_qty
      # @option options [String] :on_hand_qty
      # @option options [String] :committed_qty
      # @option options [String] :backorder_qty
      # @option options [String] :on_purchase_qty
      # @option options [int] :foreground_color
      # @option options [int] :background_color
      # @option options [Hash] :primary_vendor
      # @option options [String] :current_po_no
      # @option options [DateTime] :po_due_date
      # @option options [String] :reorder_point
      # @option options [String] :minimum_buy_qty
      # @option options [String] :current_cost
      # @option options [String] :average_cost
      # @option options [Float] :standard_cost
      # @option options [String] :buy_measure_code
      # @option options [String] :stock_measure_code
      # @option options [String] :sell_measure_code
      # @option options [String] :alternate_part_no
      # @option options [String] :accessory_whse
      # @option options [String] :accessory_part_no
      # @option options [String] :product_code
      # @option options [String] :group_no
      # @option options [int] :sales_dept
      # @option options [String] :user_def1
      # @option options [String] :user_def2
      # @option options [boolean] :discountable
      # @option options [String] :weight
      # @option options [String] :pack_size
      # @option options [boolean] :allow_back_orders
      # @option options [boolean] :allow_returns
      # @option options [String] :duty_pct
      # @option options [String] :freight_pct
      # @option options [String] :manufacture_country
      # @option options [String] :harmonized_code
      # @option options [String] :extended_description
      # @option options [Hash] :unit_of_measures
      # @option options [Hash] :pricing
      # @option options [Array] :images
      # @option options [DateTime] :default_expiry_date
      # @option options [String] :lot_consume_type
      # @option options [boolean] :upload
      #
      # @raise [Spire::Error] if the item could not be created.
      #
      # @return [Spire::Item]
      def create(options)
        client.create(:item,
          'whse' => options[:whse],
          'partNo' => options[:part_no],
          'description' => options[:description],
          'type' => options[:type],
          'status' => options[:status],
          'lotNumbered' => options[:lot_numbered],
          'serialized' => options[:serialized],
          'availableQty' => options[:available_qty],
          'onHandQty' => options[:on_hand_qty],
          'committedQty' => options[:committed_qty],
          'backorderQty' => options[:backorder_qty],
          'onPurchaseQty' => options[:on_purchase_qty],
          'foregroundColor' => options[:foreground_color],
          'backgroundColor' => options[:background_color],
          'primaryVendor' => options[:primary_vendor],
          'currentPoNo' => options[:current_po_no],
          'poDueDate' => options[:po_due_date],
          'reorderPoint' => options[:reorder_point],
          'minimumBuyQty' => options[:minimum_buy_qty],
          'currentCost' => options[:current_cost],
          'averageCost' => options[:average_cost],
          'standardCost' => options[:standard_cost],
          'buyMeasureCode' => options[:buy_measure_code],
          'stockMeasureCode' => options[:stock_measure_code],
          'sellMeasureCode' => options[:sell_measure_code],
          'alternatePartNo' => options[:alternate_part_no],
          'accessoryWhse' => options[:accessory_whse],
          'accessoryPartNo' => options[:accessory_part_no],
          'productCode' => options[:product_code],
          'groupNo' => options[:group_no],
          'salesDept' => options[:sales_dept],
          'userDef1' => options[:user_def1],
          'userDef2' => options[:user_def2],
          'discountable' => options[:discountable],
          'weight' => options[:weight],
          'packSize' => options[:pack_size],
          'allowBackorders' => options[:allow_back_orders],
          'allowReturns' => options[:allow_returns],
          'dutyPct' => options[:duty_pct],
          'freightPct' => options[:freight_pct],
          'manufactureCountry' => options[:manufacture_country],
          'harmonizedCode' => options[:harmonized_code],
          'extendedDescription' => options[:extended_description],
          'unitOfMeasures' => options[:unit_of_measures],
          'pricing' => options[:pricing],
          'images' => options[:images],
          'defaultExpiryDate' => options[:default_expiry_date],
          'lotConsumeType' => options[:lot_consume_type],
          'upload' => options[:upload]
        )
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
    # @option fields [String] :whse The wharehouse where the items is located
    # @option fields [String] :part_no The part number of the new item
    # @option fields [String] :description The description of the new item
    # @option fields [String] :type
    # @option fields [int] :status
    # @option fields [boolean] :lot_numbered
    # @option fields [boolean] :serialized
    # @option fields [String] :available_qty
    # @option fields [String] :on_hand_qty
    # @option fields [String] :committed_qty
    # @option fields [String] :backorder_qty
    # @option fields [String] :on_purchase_qty
    # @option fields [int] :foreground_color
    # @option fields [int] :background_color
    # @option fields [Hash] :primary_vendor
    # @option fields [String] :current_po_no
    # @option fields [DateTime] :po_due_date
    # @option fields [String] :reorder_point
    # @option fields [String] :minimum_buy_qty
    # @option fields [String] :current_cost
    # @option fields [String] :average_cost
    # @option fields [Float] :standard_cost
    # @option fields [String] :buy_measure_code
    # @option fields [String] :stock_measure_code
    # @option fields [String] :sell_measure_code
    # @option fields [String] :alternate_part_no
    # @option fields [String] :accessory_whse
    # @option fields [String] :accessory_part_no
    # @option fields [String] :product_code
    # @option fields [String] :group_no
    # @option fields [int] :sales_dept
    # @option fields [String] :user_def1
    # @option fields [String] :user_def2
    # @option fields [boolean] :discountable
    # @option fields [String] :weight
    # @option fields [String] :pack_size
    # @option fields [boolean] :allow_back_orders
    # @option fields [boolean] :allow_returns
    # @option fields [String] :duty_pct
    # @option fields [String] :freight_pct
    # @option fields [String] :manufacture_country
    # @option fields [String] :harmonized_code
    # @option fields [String] :extended_description
    # @option fields [Hash] :unit_of_measures
    # @option fields [Hash] :pricing
    # @option fields [Array] :images
    # @option fields [DateTime] :default_expiry_date
    # @option fields [String] :lot_consume_type
    # @option fields [boolean] :upload
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
        whse: whse,
        partNo: part_no,
        description: description,
        type: type,
        status: status || ACTIVE,
        lotNumbered: lot_numbered || false,
        serialized: serialized || false,
        availableQty: available_qty,
        onHandQty: on_hand_qty,
        committedQty: committed_qty,
        backorderQty: backorder_qty,
        onPurchaseQty: on_purchase_qty,
        foregroundColor: foreground_color || 0,
        backgroundColor: background_color || 16777215,
        currentPoNo: current_po_no,
        poDueDate: po_due_date,
        reorderPoint: reorder_point,
        minimumBuyQty: minimum_buy_qty,
        currentCost: current_cost,
        averageCost: average_cost,
        standardCost: standard_cost,
        buyMeasureCode: buy_measure_code,
        stockMeasureCode: stock_measure_code,
        sellMeasureCode: sell_measure_code,
        alternatePartNo: alternate_part_no,
        accessoryWhse: accessory_whse,
        accessoryPartNo: accessory_part_no,
        productCode: product_code,
        groupNo: group_no,
        salesDept: sales_dept,
        userDef1: user_def1,
        userDef2: user_def2,
        discountable: discountable || true,
        weight: weight,
        packSize: pack_size,
        allowBackorders: allow_back_orders || true,
        allowReturns: allow_returns || true,
        dutyPct: duty_pct,
        freightPct: freight_pct,
        manufactureCountry: manufacture_country,
        harmonizedCode: harmonized_code,
        extendedDescription: extended_description,
        unitOfMeasures: unit_of_measures || {},
        pricing: pricing || {},
        images: images  || [],
        defaultExpiryDate: default_expiry_date,
        lotConsumeType: lot_consume_type,
        upload: upload || false
      }

      # primaryVendor can't be any value if not present
      if !primary_vendor.nil? && !primary_vendor.eql?({})
        options[:primaryVendor] = primary_vendor
      end

      from_response client.post("/inventory/items/", options)
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

      client.put("/inventory/items/#{id}", payload)
    end

    # Delete this item
    #
    # @return [String] the JSON response from the Spire API
    def delete
      client.delete("/inventory/items/#{id}")
    end

    # Sets status to inactive.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_inactive
      self.status = INACTIVE
    end

    # Sets status to on hold.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def put_on_hold
      self.status = ON_HOLD
    end

    # Sets status to active.
    # This will not make any changes on Spire.
    # If you want to save changes to Spire call .save or .update!
    def make_active
      self.status = ACTIVE
    end

    # Is the record valid?
    def valid?
      !part_no.nil? && !description.nil?
    end
  end
end