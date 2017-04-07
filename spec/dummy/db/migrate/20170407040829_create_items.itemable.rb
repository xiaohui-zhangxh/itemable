class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :itemable_items do |t|
      t.string :type

      t.timestamps
    end
  end
end
