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
        @material.material_type = ''
        @material.valid?
        expect(@material.errors.full_messages).to include('材質を入力してください')
      end
      it 'categoryが空白だと登録できない' do
        @material.category = ''
        @material.valid?
        expect(@material.errors.full_messages).to include('種類を入力してください')
      end
      it 'thicknessが空白だと登録できない' do
        @material.thickness = ''
        @material.valid?
        expect(@material.errors.full_messages).to include('厚さを入力してください')
      end
      it 'thicknessが文字列だと登録できない' do
        @material.thickness = '６'
        @material.valid?
        expect(@material.errors.full_messages).to include('厚さは数値で入力してください')
      end
      it 'thicknessが0以下だと登録できない' do
        @material.thickness = 0
        @material.valid?
        expect(@material.errors.full_messages).to include('厚さは0より大きい値にしてください')
      end
      it 'widthが文字列だと登録できない' do
        @material.width = '３０'
        @material.valid?
        expect(@material.errors.full_messages).to include('幅は数値で入力してください')
      end
      it 'widthが0以下だと登録できない' do
        @material.width = 0
        @material.valid?
        expect(@material.errors.full_messages).to include('幅は0より大きい値にしてください')
      end
      it 'lengthが空白だと登録できない' do
        @material.length = ''
        @material.valid?
        expect(@material.errors.full_messages).to include('長さを入力してください')
      end
      it 'lengthが文字列だと登録できない' do
        @material.length = '４０００'
        @material.valid?
        expect(@material.errors.full_messages).to include('長さは数値で入力してください')
      end
      it 'lengthが0以下だと登録できない' do
        @material.length = 0
        @material.valid?
        expect(@material.errors.full_messages).to include('長さは0より大きい値にしてください')
      end
      it 'stockが空白だと登録できない' do
        @material.stock = ''
        @material.valid?
        expect(@material.errors.full_messages).to include('在庫数を入力してください')
      end
      it 'stockが文字列だと登録できない' do
        @material.stock = '３'
        @material.valid?
        expect(@material.errors.full_messages).to include('在庫数は数値で入力してください')
      end
      it 'stockが0より小さいと登録できない' do
        @material.stock = -1
        @material.valid?
        expect(@material.errors.full_messages).to include('在庫数は0.0以上の値にしてください')
      end
      it 'material_idが空白だと登録できない' do
        @material.material_id = ''
        @material.valid?
        expect(@material.errors.full_messages).to include('Materialを入力してください')
      end
    end
  end
end