require 'rails_helper'

RSpec.describe PartsRelation, type: :model do
  describe '必要部品登録' do
    before do
      @parent = FactoryBot.create(:part)
      @child = FactoryBot.create(:part, user_id: @parent.user_id)
      @parts_relation = PartsRelation.new(parent_id: @parent.id, child_id: @child.id, necessary_nums: 10, user_id: @parent.user_id)
    end
    context '必要部品登録できる場合' do
      it '必要な条件が揃っていて、親が完成品、子が部品は登録できる' do
        @parent.finished = true
        expect(@parts_relation).to be_valid
      end
      it '必要な条件が揃っていて、親が部品、子が部品は登録できる' do
        expect(@parts_relation).to be_valid
      end
    end
    context '必要部品登録できない場合' do
      it '完成品は子になれない' do
        @child.update(finished: true)
        valid_check(@parts_relation, '登録部品は完成品です。部品には出来ません', true)
      end
      it 'necessary_numsが空白では登録できない' do
        @parts_relation.necessary_nums = ''
        valid_check(@parts_relation, '必要数は数値で入力してください', true)
      end
      it 'necessary_numsは文字列では登録できない' do
        @parts_relation.necessary_nums = '０'
        valid_check(@parts_relation, '必要数は数値で入力してください', true)
      end
      it 'necessary_numsは0以下の数値では登録できない' do
        @parts_relation.necessary_nums = 0
        valid_check(@parts_relation, '必要数は0より大きい値にしてください', true)
      end
      it '親の先祖と子の子孫に同じ部品がある場合は登録できない' do
        duplicate = FactoryBot.create(:part, user_id: @parent.user_id)
        parent = @child
        3.times do |num|
          child = FactoryBot.create(:part, user_id: parent.user_id)
          if num < 2
            relation = PartsRelation.create(parent_id: parent.id, child_id: child.id, necessary_nums: num + 1, user_id: parent.user_id)
          else
            relation = PartsRelation.create(parent_id: parent.id, child_id: duplicate.id, necessary_nums: num + 1, user_id: parent.user_id)
          end
          parent = child
        end
        child = @parent
        3.times do |num|
          parent = FactoryBot.create(:part, user_id: child.user_id)
          if num < 2
            relation = PartsRelation.create(parent_id: parent.id, child_id: child.id, necessary_nums: num + 1, user_id: child.user_id)
          else
            relation = PartsRelation.create(parent_id: duplicate.id, child_id: child.id, necessary_nums: num + 1, user_id: child.user_id)
          end
          child = parent
        end
        valid_check(@parts_relation, '登録部品はこの完成品/部品の作成に必要な部品にすることができません', true)
      end
    end
  end
end

