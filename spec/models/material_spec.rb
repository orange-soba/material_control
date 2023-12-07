require 'rails_helper'

RSpec.describe Material, type: :model do
  describe '材料の新規登録' do
    before do
      @material = FactoryBot.build(:material)
    end
    
    context '新規登録できる場合' do
      it '全ての情報が揃っていれば新規登録できる' do
        expect(@material).to be_valid
      end
      it 'widthは空白でも登録できる' do
        @material.width = ''
        expect(@material).to be_valid
      end
      it 'optinoは空白でも登録できる' do
        @material.option = ''
        expect(@material).to be_valid
      end
    end
    context '新規登録できない場合' do
      it 'material_typeが空白だと登録できない' do
      end
      it 'categoryが空白だと登録できない' do
      end
      it 'thicknessが空白だと登録できない' do
      end
      it 'thicknessが文字列だと登録できない' do
      end
      it 'thicknessが0以下だと登録できない' do
      end
      it 'widthが文字列だと登録できない' do
      end
      it 'widthが0以下だと登録できない' do
      end
      it 'lengthが空白だと登録できない' do
      end
      it 'lengthが文字列だと登録できない' do
      end
      it 'lengthが0以下だと登録できない' do
      end
      it 'stockが空白だと登録できない' do
      end
      it 'stockが文字列だと登録できない' do
      end
      it 'stockが0より小さいと登録できない' do
      end
      it 'material_idが空白だと登録できない' do
      end
    end
  end
end