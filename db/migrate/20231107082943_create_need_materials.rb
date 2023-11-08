class CreateNeedMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :need_materials do |t|
      t.references :part,        null: false, foreign_key: true
      t.integer :material_id,    null: false
      t.float :length,           null: false
      t.float :length_option
      t.integer :necessary_nums, null: false
      t.references :user,        null: false, foreign_key: true
      t.timestamps
    end
  end
end
