require 'rails_helper'

RSpec.describe Part, type: :model do
  describe '完成品/部品新規登録' do
    before do
      @part = FactoryBot.build(:part)
    end
    context '新規登録できる場合' do
      it '必要な情報が揃っていれば登録できる(finishedがfalse:部品)' do
      end
      it 'finishedがtrue(完成品)でも登録できる' do
      end
    end
    context '新規登録できない場合' do
      it 'nameが空白だと登録できない' do
      end
      it 'stockが空白だと登録できない' do
      end
      it 'finishedが空白だと登録できない' do
      end
      it '同じユーザーが同じnameのpartを登録できない' do
      end
      it 'stockは文字列だと登録できない' do
      end
      it 'stockは全角の数字だと登録できない' do
      end
      it 'userに紐づいていないと登録できない' do
      end
    end
  end
end