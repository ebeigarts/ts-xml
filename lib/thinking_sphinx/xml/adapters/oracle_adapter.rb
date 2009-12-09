module ThinkingSphinx
  class OracleAdapter < AbstractAdapter
    def setup
      create_group_concat_function
      create_crc32_function
    end
    
    def sphinx_identifier
      "odbc"
    end
    
    def concatenate(clause, separator = ' ')
      clause.split(', ').collect { |field| field }.join(" || '#{separator}' || ")
    end
    
    def group_concatenate(clause, separator = ' ')
      "TO_STRING(CAST(COLLECT(TO_CHAR(#{clause})) AS SYS.ODCIVARCHAR2LIST), '#{separator}')"
    end
    
    def cast_to_string(clause)
      "TO_CHAR(#{clause})"
    end
    
    def cast_to_datetime(clause)
      "(TO_DATE(TO_CHAR(#{clause}, 'YYYY-MON-DD HH24.MI.SS'), 'YYYY-MON-DD HH24.MI.SS') - TO_DATE('01-JAN-1970','DD-MON-YYYY')) * (86400)"
    end
    
    def cast_to_unsigned(clause)
      "CAST(#{clause} AS NUMBER(10,0))"
    end
    
    def convert_nulls(clause, default = '')
      return clause if default == ''
      default = "'#{default}'" if default.is_a?(String)
      "NVL(#{clause},#{default})"
    end
    
    def boolean(value)
      value ? '1' : '0'
    end
    
    # TODO
    def crc(clause, blank_to_null = false)
      "CRC32(#{clause})"
    end
    
    def utf8_query_pre
      nil
    end
    
    def time_difference(diff)
      "SYSDATE - #{diff}/(86400)"
    end
    
    def select_each(query)
      cursor = connection.raw_connection.exec(query)
      col_names = cursor.get_col_names.collect(&:downcase)
      while values = cursor.fetch
        hash_values = Hash[*col_names.zip(values).flatten]
        yield hash_values
      end
    ensure
      cursor.close if cursor
    end
    
    private
    
    # Requires Oracle 10g+
    # Return only first 4000 bytes
    def create_group_concat_function
      connection.execute <<-SQL
        CREATE OR REPLACE FUNCTION to_string (
          nt_in IN SYS.ODCIVARCHAR2LIST,
          delimiter_in IN VARCHAR2 DEFAULT ','
        ) RETURN VARCHAR2 IS
          v_idx PLS_INTEGER;
          v_str VARCHAR2(4000);
          v_dlm VARCHAR2(1);
        BEGIN
          v_idx := nt_in.FIRST;
          WHILE v_idx IS NOT NULL LOOP
            v_str := SUBSTRB(v_str || v_dlm || nt_in(v_idx), 1, 4000);
            v_dlm := delimiter_in;
            v_idx := nt_in.NEXT(v_idx);
          END LOOP;
          RETURN v_str;
        END to_string;
      SQL
    end
    
    # Requires Oracle 10g+
    def create_crc32_function
      connection.execute <<-SQL
        CREATE OR REPLACE FUNCTION crc32(
          word IN VARCHAR2
        ) RETURN NUMBER IS
          code NUMBER(4,0);
          i NUMBER(10,0);
          j NUMBER(1,0);
          tmp NUMBER(10,0);
          tmp_a NUMBER(10,0);
          tmp_b NUMBER(10,0);
        BEGIN
          tmp := 4294967295;
          i := 0;
          WHILE i < length(word) LOOP
            code := ascii(SUBSTR(word, i + 1, 1));
            tmp := tmp - 2 * to_number(bitand(tmp, code)) + code;
            j := 0;
            WHILE j < 8 LOOP
              tmp_a := floor(tmp / 2);
              tmp_b := 3988292384 * to_number(bitand(tmp, 1));
              tmp := tmp_a - 2 * to_number(bitand(tmp_a, tmp_b)) + tmp_b;
              j := j + 1;
            END LOOP;
            i := i + 1;
          END LOOP;
          RETURN tmp - 2 * to_number(bitand(tmp, 4294967295)) + 4294967295;
        END crc32;
      SQL
    end
  end
end