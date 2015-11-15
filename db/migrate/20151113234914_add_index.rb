class AddIndex < ActiveRecord::Migration
  def change
    add_index :entries, [:title]
    add_index :entry_word_relations, [:entry_id, :word_id]
    add_index :words, [:surface_form, :pos, :basic_form]
    add_index :keywords, [:entry_id, :word_id]
  end
end
