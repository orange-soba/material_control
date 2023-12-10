class Material < ApplicationRecord
  belongs_to :user
  
  with_options presence: true do
    validates :material_type, :category, :material_id
    validates :stock, numericality: { allow_nil: true, greater_than_or_equal_to: 0.0 }
    validates :thickness, :length, numericality: { allow_nil: true, only_integer: true, greater_than: 0 }
  end

  validates :width, numericality: { allow_nil: true, only_integer: true, greater_than: 0 }

  def display_combine
    ret = "#{material_type} / #{category} / #{thickness}"
    if width != ""
      ret += " * #{width}"
    end
    if option != ""
      ret += " / #{option}"
    end

    ret
  end

  def destroy
    needs = NeedMaterial.where(material_id: material_id)
    ActiveRecord::Base.transaction do
      needs.each { |need| need.destroy! }
      super
      # raise ActiveRecord::RecordNotDestroyed.new("削除に失敗しました:Test") # エラーの確認用
    rescue => e
      Rails.logger.debug e.message
      errors.add(:base, "エラーが発生しました: #{e.message}")
      return false
    end
  end
end
