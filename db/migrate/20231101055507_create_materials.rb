class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :material_type, null: false
      t.string :category,      null: false
      t.integer :thickness,    null: false
      t.integer :width
      t.string :option
      t.integer :length,       null: false
      t.float :stock,          null: false
      t.integer :material_id,  null: false
      t.references :user,      null: false, foreign_key: true
      t.timestamps
    end
  end
end
