class AddOrderDestinationToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :order_destination, :string
  end
end
