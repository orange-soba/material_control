require 'rails_helper'

RSpec.describe "材料の新規登録", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @material = FactoryBot.build(:material)
  end

  context '材料の新規登録ができる場合' do
    it '正しい情報を入力すれば材料の新規登録ができ、登録履歴に入力した情報が表示される' do
    end
  end
  context '材料の新規登録ができない場合' do
    it 'ログインしていないと材料の新規ページへ遷移できない' do
    end
    it '誤った情報を入力すると新規登録ができず、新規登録ページへ戻ってくる' do
    end
  end
end
