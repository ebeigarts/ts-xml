module ThinkingSphinx
  class Source
    def initialize_with_oracle_database_configuration(index, options = {})
      connection = index.model.connection
      if connection.class.name == "ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter"
        connection.instance_variable_set(:@config, connection.raw_connection.instance_variable_get(:@config))
      end
      initialize_without_oracle_database_configuration(index, options)
    end
    
    alias_method_chain :initialize, :oracle_database_configuration
    
    def to_riddle_for_core(offset, position)
      source = Riddle::Configuration::XMLSource.new(
        "#{index.core_name}_#{position}", "xmlpipe2"
      )
      
      set_source_xml_settings       source, offset
      set_source_attributes         source, offset
      set_source_settings           source
      
      source
    end
    
    def to_riddle_for_delta(offset, position)
      source = Riddle::Configuration::XMLSource.new(
        "#{index.delta_name}_#{position}", "xmlpipe2"
      )
      source.parent = "#{index.core_name}_#{position}"
      
      set_source_xml_settings       source, offset
      set_source_attributes         source, offset
      set_source_settings           source
      
      source
    end
    
    private
    
    def set_source_xml_settings(source, offset)
      env = ThinkingSphinx::Configuration.instance.environment
      database = ENV['DATABASE'] || 'mysql'
      source.xmlpipe_command = "rake -s ts:xml NAME=#{source.name} OFFSET=#{offset} RAILS_ENV=#{env} MERB_ENV=#{env} DATABASE=#{database}"
      @fields.each do |field|
        source.xmlpipe_field << field.unique_name
      end
    end
    
    def set_source_attributes(source, offset)
      attributes.each do |attrib|
        type = attrib.type_to_config.to_s.sub("sql_", "xmlpipe_")
        source.send(type) << attrib.unique_name
      end
    end
  end
end
