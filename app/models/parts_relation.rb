class PartsRelation < ApplicationRecord
  belongs_to :parent, class_name: "Part"
  belongs_to :child, class_name: "Part"
  belongs_to :user

  with_options on: :create do
    validate :cannot_treat_as_parts
    validate :disallow_same
    validate :disallow_roop
  end
  validates :necessary_nums, numericality: { only_integer: true, greater_than: 0 }

  def cannot_treat_as_parts
    return unless child_id

    part = Part.find(child_id)
    return unless part.finished

    errors.add(:child, "は完成品です。部品には出来ません")
  end

  def disallow_same
    check_relation = PartsRelation.find_by(
      parent_id: self.parent_id,
      child_id: self.child_id,
      user_id: self.user_id
    )
  
    if check_relation.present?
      errors.add(:child, "はすでに必要部品として登録済みです。")
    end
  end
  

  def disallow_roop
    return if roop_check

    errors.add(:child, "はこの完成品/部品の作成に必要な部品にすることができません")
  end

  def roop_check
    return true unless child_id
    
    descendants = []
    PartsTracer.trace_descendants_arr(child_id, descendants)
    ancestors = []
    PartsTracer.trace_ancestors_arr(parent_id, ancestors)

    descendants.each do |descendant|
      ancestors.each do |ancestor|
        return if descendant == ancestor
      end
    end

    true
  end

  # def destroy # エラーを意図的に発生
  #   ActiveRecord::Base.transaction do
  #     super
  #     raise ActiveRecord::RecordNotDestroyed.new("削除に失敗しました:Test") # エラーの確認用
  #   rescue => e
  #     Rails.logger.debug e.message
  #     errors.add(:base, "エラーが発生しました: #{e.message}")
  #     return false
  #   end
  # end
end
