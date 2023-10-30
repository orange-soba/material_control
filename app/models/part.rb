class Part < ApplicationRecord
  belongs_to :user
  
  with_options presence: true do
    validates :name, :stock, :finished
  end
end
