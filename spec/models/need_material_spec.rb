require 'rails_helper'

RSpec.describe NeedMaterial, type: :model do
  describe '必要材料の新規登録' do
    context '新規登録できる場合' do
      it '必要な情報が揃っていれば登録できる' do
      end
      it 'length_optionが空白でも登録できる' do
      end
    end
    context '新規登録できない場合' do
      it 'partが空だと登録できない' do
      end
      it 'material_idが空白だと登録できない' do
      end
      it 'lengthが空白だと登録できない' do
      end
      it 'lengthが文字列だと登録できない' do
      end
      it 'lengthが0以下だと登録できない' do
      end
      it 'necessary_numsが空白だと登録できない' do
      end
      it 'necessary_numsが文字列だと登録できない' do
      end
      it 'necessary_numsが0以下だと登録できない' do
      end
      it 'userが空だと登録出来ない' do
      end
    end
  end
end
