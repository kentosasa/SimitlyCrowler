class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :surface_form
      t.string :pos
      t.string :basic_form

      t.timestamps null: false
    end
  end
end
