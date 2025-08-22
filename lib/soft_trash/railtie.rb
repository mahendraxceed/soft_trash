require 'soft_trash/schema_definitions'

module SoftTrash
  class Railtie < Rails::Railtie
    initializer 'soft_trash.table_definition_extensions' do
      ActiveSupport.on_load :active_record do
        ActiveRecord::ConnectionAdapters::TableDefinition.include SoftTrash::SchemaDefinitions
      end
    end
  end
end
