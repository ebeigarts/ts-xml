module ThinkingSphinx
  class AbstractAdapter
    def self.detect(model)
      case model.connection.class.name
      when "ActiveRecord::ConnectionAdapters::MysqlAdapter",
           "ActiveRecord::ConnectionAdapters::MysqlplusAdapter"
        ThinkingSphinx::MysqlAdapter.new model
      when "ActiveRecord::ConnectionAdapters::PostgreSQLAdapter"
        ThinkingSphinx::PostgreSQLAdapter.new model
      when "ActiveRecord::ConnectionAdapters::SQLite3Adapter"
        ThinkingSphinx::SQLite3Adapter.new model
      when "ActiveRecord::ConnectionAdapters::OracleAdapter",
           "ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter"
        ThinkingSphinx::OracleAdapter.new model
      when "ActiveRecord::ConnectionAdapters::JdbcAdapter"
        if model.connection.config[:adapter] == "jdbcmysql"
          ThinkingSphinx::MysqlAdapter.new model
        elsif model.connection.config[:adapter] == "jdbcpostgresql"
          ThinkingSphinx::PostgreSQLAdapter.new model
        else
          raise "Invalid Database Adapter: Sphinx only supports MySQL and PostgreSQL"
        end
      else
        raise "Invalid Database Adapter: Sphinx only supports MySQL and PostgreSQL, not #{model.connection.class.name}"
      end
    end
    
    def select_each(query)
      connection.select_all(query).each do |values|
        yield values
      end
    end
  end
end
