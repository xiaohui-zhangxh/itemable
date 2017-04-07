class CreateItems < <%= migration_parent %>
  def change
    create_table :itemable_items do |t|
      t.string :type
      t.string :name
      t.timestamps
    end
  end
end
