class AddOrderDestinationToParts < ActiveRecord::Migration[7.0]
  def change
    add_column :parts, :order_destination, :string
  end
end
