class AddWordIndex < ActiveRecord::Migration
  def change
    add_index :entry_word_relations, [:entry_id]
    add_index :entry_contents, [:entry_id]
  end
end
