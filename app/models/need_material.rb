class NeedMaterial < ApplicationRecord
  belongs_to :user
  belongs_to :part
  
  with_options presence: true do
    validates :material_id
    validates :length,         numericality: { allow_nil: true, message: 'は半角の数値で入力してください' }
    validates :necessary_nums, numericality: { only_integer: true, allow_nil: true, message: 'は半角の数値で入力してください' }
  end
end
