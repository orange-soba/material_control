class Material < ApplicationRecord
  belongs_to :user
  
  with_options presence: true do
    validates :material_type, :category, :thickness, :length, :stock, :material_id
  end
end
