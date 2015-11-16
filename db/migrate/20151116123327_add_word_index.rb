class AddWordIndex < ActiveRecord::Migration
  def change
    add_index :entry_word_relations, [:entry_id]
  end
end
