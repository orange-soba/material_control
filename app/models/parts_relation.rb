class PartsRelation < ApplicationRecord
  belongs_to :parent, class_name: "Part"
  belongs_to :child, class_name: "Part"

  validates :necessary_nums, numericality: { only_integer: true, messge: 'は半角の数値で入力してください' }
  validate :cannot_treat_as_parts
  validate :disallow_roop

  def cannot_treat_as_parts
    part = Part.find(child_id)
    return unless part.finished

    errors.add(:child, "は完成品です。部品には出来ません")
  end

  def disallow_roop
    return unless trace_ancestors(parent_id, child_id)

    errors.add(:child, "はこの完成品/部品の作成に必要な部品になることができません")
  end

  def trace_ancestors(parent_id, child_id)
    parent = Part.find(parent_id)
    return false if parent.nil?

    return true if parent_id == child_id

    parent.parents.each do |grand_parent|
      return true if trace_ancestors(grand_parent.id, child_id)
    end

    false
  end
  
end
