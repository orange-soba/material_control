require 'rails_helper'

RSpec.describe Part, type: :model do
  describe '完成品/部品新規登録' do
    before do
      @part = FactoryBot.build(:part)
    end
    context '新規登録できる場合' do
      it '必要な情報が揃っていれば登録できる(finishedがfalse:部品)' do
        expect(@part).to be_valid
      end
      it 'finishedがtrue(完成品)でも登録できる' do
        @part.finished = true
        expect(@part).to be_valid
      end
    end
    context '新規登録できない場合' do
      it 'nameが空白だと登録できない' do
        @part.name = ''
        @part.valid?
        expect(@part.errors.full_messages).to include('完成品名/部品名を入力してください')
      end
      it 'stockが空白だと登録できない' do
        @part.stock = ''
        @part.valid?
        expect(@part.errors.full_messages).to include('在庫数を入力してください')
      end
      it 'finishedが空白だと登録できない' do
        @part.finished = nil
        @part.valid?
        expect(@part.errors.full_messages).to include('完成品か否かは一覧にありません')
      end
      it '同じユーザーが同じnameのpartを登録できない' do
        @part.save
        another_part = FactoryBot.build(:part)
        another_part.user = @part.user
        another_part.name = @part.name
        another_part.valid?
        expect(another_part.errors.full_messages).to include('完成品名/部品名はすでに存在します')
      end
      it 'stockは文字列(全角の数字)だと登録できない' do
        @part.stock = '０'
        @part.valid?
        expect(@part.errors.full_messages).to include('在庫数は半角の数値で入力してください')
      end
      it 'userに紐づいていないと登録できない' do
        @part.user = nil
        @part.valid?
        expect(@part.errors.full_messages).to include('ユーザーを入力してください')
      end
    end
  end
end