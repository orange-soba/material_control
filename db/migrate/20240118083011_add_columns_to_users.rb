class AddColumnsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :post_code,     :string
    add_column :users, :prefecture_id, :integer
    add_column :users, :city,          :string
    add_column :users, :house_number,  :string
    add_column :users, :building,      :string
    add_column :users, :phone_number,  :string
  end
end
