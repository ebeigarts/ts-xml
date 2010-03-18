require 'rubygems'
require 'cucumber'
require 'spec'
require 'fileutils'
require 'ginger'
require 'will_paginate'
require 'active_record'

$:.unshift File.dirname(__FILE__) + '/../../../lib'
$:.unshift File.dirname(__FILE__) + '/../../../vendor/thinking_sphinx/lib'

require 'cucumber/thinking_sphinx/internal_world'

world = Cucumber::ThinkingSphinx::InternalWorld.new
world.database_file = 'features_ext/support/database.yml'
world.configure_database

# Oracle
if defined?(ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter)
  # CLOBs are not supported yet.
  ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter::NATIVE_DATABASE_TYPES[:text] = { :name => "VARCHAR2", :limit => 4000 }

  ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
    self.default_sequence_start_value = "1 NOCACHE INCREMENT BY 1"

    # Avoid problems in Robot model when prefetch_primary_key? is true.
    def create_table_with_trigger(name, options = {}, &block)
      create_table_without_trigger(name, options.merge(:primary_key_trigger => true), &block)
    end
    alias_method_chain :create_table, :trigger
  end
end

require "thinking_sphinx/xml"

world.setup
