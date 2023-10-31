class CreateParts < ActiveRecord::Migration[7.0]
  def change
    create_table :parts do |t|
      t.string :name,      null: false
      t.integer :stock,    null: false
      t.boolean :finished, null: false
      t.references :user,  null: false, foreign_key: true
      t.timestamps
    end
  end
end
