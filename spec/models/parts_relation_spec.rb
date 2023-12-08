require 'rails_helper'

RSpec.describe PartsRelation, type: :model do
  describe '必要部品登録' do
    context '必要部品登録できる場合' do
      it '必要な条件が揃っていて、親が完成品、子が部品は登録できる' do
      end
      it '必要な条件が揃っていて、親が部品、子が部品は登録できる' do
      end
    end
    context '必要部品登録できない場合' do
      it '完成品は子になれない' do
      end
      it 'necessary_numsが空白では登録できない' do
      end
      it 'necessary_numsは文字列では登録できない' do
      end
      it 'necessary_numsは0以下の数値では登録できない' do
      end
      it '子の子に親がいる場合は登録できない' do
      end
      it '親の親に子がいる場合は登録できない' do
      end
    end
  end
end
