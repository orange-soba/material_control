class Part < ApplicationRecord
  belongs_to :user
  
  with_options presence: true do
    validates :name, :stock
  end
  validates :finished, inclusion: { in: [true, false] }
end
