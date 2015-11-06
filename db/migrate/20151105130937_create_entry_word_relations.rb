class CreateEntryWordRelations < ActiveRecord::Migration
  def change
    create_table :entry_word_relations do |t|
      t.integer :entry_id
      t.integer :word_id
      t.integer :position

      t.timestamps null: false
    end
  end
end
