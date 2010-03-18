module ThinkingSphinx
  class SQLite3Adapter < AbstractAdapter
    def setup
      create_group_concat_function
      create_crc32_function
    end
    
    def sphinx_identifier
      "sqlite3"
    end
    
    def concatenate(clause, separator = ' ')
      clause.split(', ').collect { |field| field }.join(" || '#{separator}' || ")
    end
    
    def group_concatenate(clause, separator = ' ')
      "GROUP_CONCAT(#{clause}, '#{separator}')"
    end
    
    def cast_to_string(clause)
      "CAST(#{clause} AS TEXT)"
    end
    
    def cast_to_datetime(clause)
      "STRFTIME('%s', #{clause}, 'utc')"
    end
    
    def cast_to_unsigned(clause)
      "CAST(#{clause} AS INTEGER)"
    end
    
    def convert_nulls(clause, default = '')
      default = "'#{default}'" if default.is_a?(String)
      "IFNULL(#{clause},#{default})"
    end
    
    def boolean(value)
      value ? "'t'" : "'f'"
    end
    
    def crc(clause, blank_to_null = false)
      "CRC32(#{clause})"
    end
    
    def utf8_query_pre
      nil
    end
    
    def time_difference(diff)
      "STRFTIME('%s','now') - STRFTIME('%s', #{diff})"
    end
    
    private
    
    def create_group_concat_function
      connection.raw_connection.create_aggregate("group_concat", 2) do
        step do |func, value, separator|
          if !value.null? && !separator.null?
            if func[:concat].nil?
              func[:concat] = value.to_s
            else
              func[:concat] << separator.to_s
              func[:concat] << value.to_s
            end
          end
        end
        finalize do |func|
          func.result = func[:concat]
        end
      end
    end
    
    def create_crc32_function
      connection.raw_connection.create_function("crc32", 1) do |func, value|
        r = 0
        if !value.null?
          c = value.to_s
          n = c.length
          r = 0xFFFFFFFF
          n.times do |i|
            r ^= c[i]
            8.times do
              if (r & 1) != 0
                r = (r >> 1) ^ 0xEDB88320
              else
                r >>= 1
              end
            end
          end
        end
        func.result = r ^ 0xFFFFFFFF
      end
    end
  end
end