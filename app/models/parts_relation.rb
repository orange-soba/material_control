class PartsRelation < ApplicationRecord
  belongs_to :parent, class_name: "Part"
  belongs_to :child, class_name: "Part"
  belongs_to :user

  validate :cannot_treat_as_parts
  validate :disallow_roop
  validates :necessary_nums, presence: true, numericality: { only_integer: true, allow_nil: true, messge: 'は半角の数値で入力してください' }

  def cannot_treat_as_parts
    return unless child_id

    part = Part.find(child_id)
    return unless part.finished

    errors.add(:child, "は完成品です。部品には出来ません")
  end

  def disallow_roop
    return if roop_check

    errors.add(:child, "はこの完成品/部品の作成に必要な部品にすることができません")
  end

  def roop_check
    return true unless child_id
    
    descendants = []
    trace_descendants_arr(child_id, descendants)
    ancestors = []
    trace_ancestors_arr(parent_id, ancestors)

    descendants.each do |descendant|
      ancestors.each do |ancestor|
        return if descendant == ancestor
      end
    end

    true
  end

  def trace_descendants_arr(child_id, descendants = [])
    child = Part.find(child_id)
    descendants << child

    child.children.each do |grand_child|
      trace_descendants_arr(grand_child.id, descendants)
    end
  end

  def trace_ancestors_arr(parent_id, ancestors = [])
    parent = Part.find(parent_id)
    ancestors << parent

    parent.parents.each do |grand_parent|
      trace_ancestors_arr(grand_parent.id, ancestors)
    end
  end
end
