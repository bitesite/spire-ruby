module Spire
  module Production
    # A template item is a record that contains items of a template
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [r] template
    #   @return [Hash]
    # @!attribute [r] whse
    #   @return [String]
    # @!attribute [r] part_no
    #   @return [String]
    # @!attribute [r] description
    #   @return [String]
    # @!attribute [r] unit_qty
    #   @return [String]
    # @!attribute [r] unit_of_measure_code
    #   @return [String]
    # @!attribute [r] created
    #   @return [String]
    # @!attribute [r] modified
    #   @return [String]
    # @!attribute [r] created_by
    #   @return [String]
    # @!attribute [r] modified_by
    #   @return [String]
    class TemplateItem < BasicData
      register_attributes :id,
                          :template,
                          :whse,
                          :part_no,
                          :description,
                          :unit_qty,
                          :unit_of_measure_code,
                          :created,
                          :modified,
                          :created_by,
                          :modified_by
                          readonly: [
                            :id,
                            :template,
                            :whse,
                            :part_no,
                            :description,
                            :unit_qty,
                            :unit_of_measure_code,
                            :created,
                            :modified,
                            :created_by,
                            :modified_by
                          ]

      SYMBOL_TO_STRING = {
        id: 'id',
        template: 'template',
        whse: 'whse',
        part_no: 'partNo',
        description: 'description',
        unit_qty: 'unitQty',
        unit_of_measure_code: 'unitOfMeasureCode',
        created: 'created',
        modified: 'modified',
        created_by: 'createdBy',
        modified_by: 'modifiedBy'
      }

      class << self
        # Find a specific template item by its id.
        #
        # @raise [Spire::Error] if the template item could not be found.
        #
        # @return [Spire::Production::TemplateItem]
        def find(id, params = {})
          client.find("/production/template_items", id, params)
        end

        # Find many template_items
        #
        # You can pass in options like q, limit, filter and any other
        # parameters that are supported by the Spire API
        #
        # @return [Spire::Production::TemplateItem]
        def find_many(options = {})
          client.find_many(Spire::Production::TemplateItem, "/production/template_items/", options)
        end

        # Search for template item by query. This will even return inactive template items!
        #
        # @raise [Spire::Error] if the template item could not be found.
        #
        # @return [Spire::Production::TemplateItem]
        def search(query)
          client.find_many(Spire::Production::TemplateItem, "/production/template_items/", { q: query })
        end
      end

      # Update the fields of a template item.
      #
      # Supply a hash of string keyed data retrieved from the Spire API representing an template item.
      #
      # Note that this method does not save anything new to the Spire API,
      # it just assigns the input attributes to your local object. If you use
      # this method to assign attributes, call `save` or `update!` afterwards if
      # you want to persist your changes to Spire.
      #
      def update_fields(fields)
        # instead of going through each attribute on self, iterate through each template in field and update from there
        self.attributes.each do |k, v|
          attributes[k.to_sym] = fields[SYMBOL_TO_STRING[k.to_sym]] || fields[k.to_sym] || attributes[k.to_sym]
        end

        attributes[:id] = fields[SYMBOL_TO_STRING[:id]] || attributes[:id]
        self
      end
    end
  end
end
