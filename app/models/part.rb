class Part < ApplicationRecord
  belongs_to :user
  
  with_options presence: true do
    validates :name
    validates :stock, numericality: { only_integere: true, allow_nil: true, message: 'は半角の数値で入力してください' }
  end
  validates :finished, inclusion: { in: [true, false] }
end
