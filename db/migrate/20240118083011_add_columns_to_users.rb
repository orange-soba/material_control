class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :post_code,     :string,  null: false
    add_column :users, :prefecture_id, :integer, null: false
    add_column :users, :city,          :string,  null: false
    add_column :users, :house_number,  :string,  null: false
    add_column :users, :building,      :string
    add_column :users, :phone_number,  :string,  null: false
  end
end
