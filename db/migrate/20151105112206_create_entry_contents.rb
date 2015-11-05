class CreateEntryContents < ActiveRecord::Migration
  def change
    create_table :entry_contents do |t|
      t.text :content
      t.text :thumbnail
      t.text :description
      t.integer :entry_id

      t.timestamps null: false
    end
  end
end
