class AddWordIdfColumn < ActiveRecord::Migration
  def change
    add_column :words, :idf, :float
  end
end
