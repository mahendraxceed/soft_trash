module SoftTrash
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      argument :model_name, type: :string, required: true, desc: "The table to add deleted_at to"

      def self.next_migration_number(dirname)
        next_migration_number = current_migration_number(dirname) + 1
        [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.3d" % next_migration_number].max
      end


      def create_migration_file
        migration_template(
          'add_deleted_at_to_tables.rb.erb',
          "db/migrate/add_deleted_at_to_#{table_name}.rb",
          migration_version: migration_version,
          table_name: table_name
        )
      end

      def inject_soft_trash_module
        model_path = "app/models/#{model_name.singularize}.rb"

        if File.exist?(model_path)
          inject_into_file model_path, after: "ApplicationRecord\n" do
            "  include SoftTrash::Model\n"
          end
        else
          create_file model_path do
            "class #{model_name.classify} < ApplicationRecord\n" +
              "  include SoftTrash::Model\n" +
              "end\n"
          end
        end
      end


      private

      def table_name
        model_name.underscore.pluralize
      end


      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]"
      end
    end
  end
end
