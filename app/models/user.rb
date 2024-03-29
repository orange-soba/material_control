class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :password, format: { with: /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i, message: 'は半角英数字（6文字以上）での入力が必須です', if: :password_required? }

  has_many :parts
  has_many :materials
  has_many :parts_relations
  has_many :need_materials

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture

  with_options presence: true do
    validates :post_code, :city, :house_number, :phone_number
    validates :prefecture_id, numericality: { allow_nil: true, other_than: 0, message: 'は必ず選択してください' }
  end
end
