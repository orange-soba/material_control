class CreatePartsRelations < ActiveRecord::Migration[7.0]
  def change
    create_table :parts_relations do |t|
      t.references :parent
      t.references :child
      t.integer :necessary_nums
      t.timestamps
    end
  end
end
