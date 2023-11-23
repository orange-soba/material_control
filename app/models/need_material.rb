class NeedMaterial < ApplicationRecord
  belongs_to :user
  belongs_to :part
  
  with_options presence: true do
    validates :material_id
    validates :length,         numericality: { allow_nil: true, message: 'は半角の数値で入力してください' }
    validates :necessary_nums, numericality: { only_integer: true, allow_nil: true, message: 'は半角の数値で入力してください' }
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
