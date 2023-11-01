class Material < ApplicationRecord
  belongs_to :user
  
  with_options presence: true do
    validates :material_type, :category, :thickness, :length, :material_id
    validates :stock, numericality: { allow_nil: true, message: 'は半角の数値で入力してください' }
  end
end
