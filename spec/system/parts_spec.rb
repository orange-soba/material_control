require 'rails_helper'

RSpec.describe "完成品/部品の新規登録", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @part = FactoryBot.build(:part)
  end

  context '完成品/部品の新規登録ができる場合' do
    it '正しい情報を入力すれば新規登録ができて、登録履歴に入力した情報が入力した情報が表示される(完成品)' do
      # ログイン
      sign_in(@user)
      # 「完成品/部品登録」ボタンを確認
      expect(page).to have_content('完成品/部品登録')
      # 登録ページへ遷移
      visit new_part_path
      # 正しい情報を入力
      fill_in '完成品名/部品名：', with: @part.name
      fill_in '在庫数：', with: @part.stock
      find('input[name="part[finished]"]').click
      # 登録ボタンをクリックするとpartモデルのカウントが1上がるのを確認
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { Part.count }.by(1)
      sleep 1
      # 登録履歴に先ほど登録した情報が完成品として表示されているのを確認
      expect(page).to have_content(@part.name)
      expect(page).to have_content(@part.stock)
      expect(page).to have_content('完成品')
    end
    it '正しい情報を入力すれば新規登録ができて、登録履歴に入力した情報が入力した情報が表示される(部品)' do
      # ログイン
      sign_in(@user)
      # 「完成品/部品登録」ボタンを確認
      expect(page).to have_content('完成品/部品登録')
      # 登録ページへ遷移
      visit new_part_path
      # 正しい情報を入力
      fill_in '完成品名/部品名：', with: @part.name
      fill_in '在庫数：', with: @part.stock
      # 登録ボタンをクリックするとpartモデルのカウントが1上がるのを確認
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { Part.count }.by(1)
      sleep 1
      # 登録履歴に先ほど登録した情報が完成品として表示されているのを確認
      expect(page).to have_content(@part.name)
      expect(page).to have_content(@part.stock)
      expect(page).to have_content('部品')
    end
  end
  context '完成品/部品の新規登録ができない場合' do
    it 'ログインしていないと新規登録ページへ遷移できない' do
    end
    it '誤った情報を入力すると新規登録が出来ず、新規登録ページへ戻ってくるのを確認' do
      # ログイン
      sign_in(@user)
      # 「完成品/部品登録」ボタンを確認
      expect(page).to have_content('完成品/部品登録')
      # 登録ページへ遷移
      visit new_part_path
      # 誤った必要情報を入力
      fill_in '完成品名/部品名：', with: ''
      fill_in '在庫数：', with: ''
      # 登録ボタンをクリックしてもpartモデルのカウントが変化しないのを確認
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { Part.count }.by(0)
      # 新規登録ページへ戻るのを確認
      expect(current_path).to eq new_part_path
    end
  end
end

RSpec.describe '完成品/部品の編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @part = FactoryBot.create(:part, user_id: @user.id)
  end

  context '編集ができる場合' do
    it '部品詳細ページで在庫の編集ができる' do
    end
    it '部品詳細ページから編集ページに遷移して情報の編集ができる' do
    end
  end
  context '編集ができない場合' do
    it 'ログインしていないと編集ページに遷移できない' do
    end
  end
end