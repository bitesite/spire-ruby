module Spire
  module Production
    # A template is a record that contains template items
    #
    # @!attribute [r] id
    #   @return [int]
    # @!attribute [r] template_no
    #   @return [String]
    # @!attribute [r] default
    #   @return [boolean]    
    # @!attribute [r] whse
    #   @return [String]
    # @!attribute [r] part_no
    #   @return [String]
    # @!attribute [r] description
    #   @return [String]
    # @!attribute [r] lead_time
    #   @return [String]
    # @!attribute [r] category
    #   @return [String]
    # @!attribute [r] priority
    #   @return [int]
    # @!attribute [r] required_qty
    #   @return [String]
    # @!attribute [r] yeild_expected_pct
    #   @return [String]
    # @!attribute [r] guid
    #   @return [String]
    # @!attribute [r] reference
    #   @return [String]
    # @!attribute [r] revision
    #   @return [String]
    # @!attribute [r] customer
    #   @return [Hash]
    # @!attribute [r] created
    #   @return [String]
    # @!attribute [r] modified
    #   @return [String]
    # @!attribute [r] created_by
    #   @return [String]
    # @!attribute [r] modified_by
    #   @return [String]
    class Template < BasicData
      register_attributes :id,
                          :template_no,
                          :default,
                          :whse,
                          :part_no,
                          :description,
                          :lead_time,
                          :category,
                          :priority,
                          :required_qty,
                          :yeild_expected_pct,
                          :guid,
                          :reference,
                          :revision,
                          :customer,
                          :created,
                          :modified,
                          :created_by,
                          :modified_by,
                          readonly: [
                            :id,
                            :template_no,
                            :default,
                            :whse,
                            :part_no,
                            :description,
                            :lead_time,
                            :category,
                            :priority,
                            :required_qty,
                            :yeild_expected_pct,
                            :guid,
                            :reference,
                            :revision,
                            :customer,
                            :created,
                            :modified,
                            :created_by,
                            :modified_by
                          ]

      SYMBOL_TO_STRING = {
        id: 'id',
        template_no: 'templateNo',
        default: 'default',
        whse: 'whse',
        part_no: 'partNo',
        description: 'description',
        lead_time: 'leadTime',
        category: 'category',
        priority: 'priority',
        required_qty: 'requiredQty',
        yeild_expected_pct: 'yeildExpectedPct',
        guid: 'guid',
        reference: 'reference',
        revision: 'revision',
        customer: 'customer',
        created: 'created',
        modified: 'modified',
        created_by: 'createdBy',
        modified_by: 'modifiedBy'
      }

      class << self
        # Find a specific template by its id.
        #
        # @raise [Spire::Error] if the template could not be found.
        #
        # @return [Spire::Production::Template]
        def find(id, params = {})
          client.find("/production/templates", id, params)
        end

        # Find many templates
        #
        # You can pass in options like q, limit, filter and any other
        # parameters that are supported by the Spire API
        #
        # @return [Spire::Production::Template]
        def find_many(options = {})
          client.find_many(Spire::Production::Template, "/production/templates/", options)
        end

        # Search for template by query. This will even return inactive templates!
        #
        # @raise [Spire::Error] if the template could not be found.
        #
        # @return [Spire::Production::Template]
        def search(query)
          client.find_many(Spire::Production::Template, "/production/templates/", { q: query })
        end
      end

      # Update the fields of a template.
      #
      # Supply a hash of string keyed data retrieved from the Spire API representing an template.
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
