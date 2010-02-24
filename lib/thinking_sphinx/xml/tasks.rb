namespace :thinking_sphinx do
  # http://www.sphinxsearch.com/docs/current.html#xmlpipe2
  desc "Streams XML data to STDOUT"
  task :xml => :app_env do
    require 'thinking_sphinx'
    require 'thinking_sphinx/xml'
    # ThinkingSphinx::Configuration.instance.load_models
    source_name = ENV["NAME"]
    # STDERR.puts "Source name: #{source_name}"
    source_name =~ /^(.+)_(delta|core)_(\d+)$/
    sphinx_name = $1
    delta = $2 == "delta"
    index_name  = "#{$1}_#{$2}"
    offset      = ENV["OFFSET"]
    ThinkingSphinx.context.prepare
    ThinkingSphinx.context.define_indexes
    index = nil
    model_klass = ThinkingSphinx.context.indexed_models.collect{ |m| m.constantize }.detect do |model|
      index = model.sphinx_indexes.detect { |i| i.name == sphinx_name }
    end
    # STDERR.puts model_klass.name
    # STDERR.puts index
    model_klass.sphinx_database_adapter.setup
    
    source = index.sources.first
    sql_query_range = source.to_sql_query_range(:delta => delta)
    sql_query = source.to_sql(:offset => offset, :delta => delta)
    
    # get $start, $end
    # STDERR.puts sql_query_range
    range_start, range_end = model_klass.connection.select_rows(sql_query_range).first.collect(&:to_i)
    sql_query = sql_query.gsub('$start', range_start.to_s).gsub('$end', range_end.to_s)
    
    # fetch sql and generate xml
    puts %{<?xml version="1.0" encoding="utf-8"?>}
    puts %{<sphinx:docset>}
    
    # results = model_klass.connection.select_all(query)
    # STDERR.puts "fetching #{start_id}.. "
    # STDERR.puts sql_query
    model_klass.sphinx_database_adapter.select_each(sql_query) do |values|
      pk_name = model_klass.primary_key_for_sphinx.to_s
      id = values.delete(pk_name)
      puts %{<sphinx:document id="#{id.to_i}">}
      values.each do |k, v|
        attribute = source.attributes.detect { |a| a.unique_name == k.to_sym }
        # STDERR.puts attribute
        case attribute && attribute.type
        when :boolean
          v = ['Y', 'T', '1', 1, true].include?(v) ? 1 : 0
        when :integer, :datetime
          v = v.to_i
        when :float
          v = v.to_f
        else
          v = v.to_s.to_xs
        end
        puts %{<#{k}>#{v}</#{k}>}
      end
      # Add MVA attributes (:ranged_query, :query)
      internal_id = values["sphinx_internal_id"]
      multi_attributes = source.attributes.select { |a| a.type == :multi && !a.include_as_association? }
      multi_attributes.each do |attribute|
        k = attribute.unique_name
        mva_query = attribute.send(:query, offset)
        mva_query_range = attribute.send(:range_query)
        # STDERR.puts "MVA_ATTRS: #{params.inspect}"
        # mva_definition, mva_query, mva_query_range = params.split(";")
        if mva_query
          mva_query = mva_query.gsub('$start', internal_id.to_s).gsub('$end', internal_id.to_s)
          printf %{<#{k}>}
          not_first = false
          model_klass.sphinx_database_adapter.select_each(mva_query) do |values|
            if not_first
              printf ","
            else
              not_first = true
            end
            printf values.values.first.to_s.to_xs
          end
          puts %{</#{k}>}
        end
      end
      puts %{</sphinx:document>}
    end
    
    puts %{</sphinx:docset>}
  end
end

namespace :ts do
  desc "Streams XML data to STDOUT"
  task :xml => "thinking_sphinx:xml"
end
