require 'rails_helper'

RSpec.describe NeedMaterial, type: :model do
  describe '必要材料の新規登録' do
    before do
      material = FactoryBot.create(:material)
      @need_material = FactoryBot.build(:need_material, material_id: material.material_id, user_id: material.user_id)
    end
    context '新規登録できる場合' do
      it '必要な情報が揃っていれば登録できる' do
        expect(@need_material).to be_valid
      end
      it 'length_optionが空白でも登録できる' do
        @need_material.length_option = ''
        expect(@need_material).to be_valid
      end
    end
    context '新規登録できない場合' do
      it 'partが空だと登録できない' do
        @need_material.part = nil
        valid_check(@need_material, '完成品/部品を入力してください', true)
      end
      it 'material_idが空白だと登録できない' do
        @need_material.material_id = ''
        valid_check(@need_material, '作成に必要な材料を入力してください', true)
      end
      it 'lengthが空白だと登録できない' do
        @need_material.length = ''
        valid_check(@need_material, '必要な長さを入力してください', true)
      end
      it 'lengthが文字列だと登録できない' do
        @need_material.length = '１'
        valid_check(@need_material, '必要な長さは数値で入力してください', true)
      end
      it 'lengthが0以下だと登録できない' do
        @need_material.length = 0
        valid_check(@need_material, '必要な長さは0より大きい値にしてください', true)
      end
      it 'necessary_numsが空白だと登録できない' do
        @need_material.necessary_nums = ''
        valid_check(@need_material, '必要数を入力してください', true)
      end
      it 'necessary_numsが文字列だと登録できない' do
        @need_material.necessary_nums = '１'
        valid_check(@need_material, '必要数は数値で入力してください', true)
      end
      it 'necessary_numsが0以下だと登録できない' do
        @need_material.necessary_nums = 0
        valid_check(@need_material, '必要数は0より大きい値にしてください', true)
      end
      it 'userが空だと登録出来ない' do
        @need_material.user = nil
        valid_check(@need_material, 'ユーザーを入力してください', true)
      end
    end
  end
end
