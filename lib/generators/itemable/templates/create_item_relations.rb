class CreateItemRelations < <%= migration_parent %>
  def change
    create_table :itemable_item_relations do |t|
      t.references :parent, polymorphic: true
      t.references :child, polymorphic: true

      t.timestamps
    end
  end
end
