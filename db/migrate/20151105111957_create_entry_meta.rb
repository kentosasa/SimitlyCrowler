class CreateEntryMeta < ActiveRecord::Migration
  def change
    create_table :entry_meta do |t|
      t.integer :count
      t.string :category
      t.integer :entry_id

      t.timestamps null: false
    end
  end
end
