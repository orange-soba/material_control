class Part < ApplicationRecord
  belongs_to :user
  has_many :need_materials, dependent: :destroy

  has_many :parent_relations, class_name: "PartsRelation", foreign_key: :parent_id, dependent: :destroy
  has_many :children, through: :parent_relations, source: :child

  has_many :child_relations, class_name: "PartsRelation", foreign_key: :child_id, dependent: :destroy
  has_many :parents, through: :child_relations, source: :parent
  
  with_options presence: true do
    validates :name, uniqueness: { scope: :user_id, message: 'はすでに存在します' }
    validates :stock, numericality: { only_integer: true, allow_nil: true, message: 'は半角の数値で入力してください' }
  end
  validates :finished, inclusion: { in: [true, false] }
end
