require_relative 'migration'
require_relative 'migration_helper'
module Itemable
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      include Itemable::Generators::MigrationHelper
      extend Itemable::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      def copy_migration
        migration_template 'create_items.rb', 'db/migrate/create_items.itemable.rb'
        migration_template 'create_item_relations.rb', 'db/migrate/create_item_relations.itemable.rb'
      end
    end
  end
end
