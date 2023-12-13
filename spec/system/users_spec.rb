require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザーの新規登録ができる時' do
    it '正しい情報を入力すれば新規登録ができて、マイページへ遷移する' do
      # BASIC認証を通過しトップページへ遷移
      sign_in_basic(root_path)
      # 「新規登録」ボタンの確認
      expect(page).to have_content('新規登録')
      # 新規登録ページへ遷移
      visit new_user_registration_path
      # ユーザー情報の入力
      fill_in '名前', with: @user.name
      fill_in 'Eメール', with: @user.email
      fill_in 'パスワード', with: @user.password
      fill_in 'パスワード（確認用）', with: @user.password_confirmation
      # 「登録」ボタンを押すとユーザーモデルのカウントが1上がるのを確認
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { User.count }.by(1)
      # マイページへ遷移することを確認
      new_user = User.last # 新規登録後、最後に作成されたユーザーを取得
      expect(page).to have_current_path(user_path(new_user))
      # ヘッダーに「ログアウト」ボタンがあるのを確認
      expect(page).to have_content('ログアウト')
      # 「新規登録」、「ログイン」ボタンがないのを確認
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ユーザーの新規登録ができない時' do
    it '誤った情報では新規登録できず、新規登録ページへ戻る' do
      # BASIC認証を通過しトップページへ遷移
      # 「新規登録」ボタンの確認
      # 新規登録ページへ遷移
      # 誤ったユーザー情報の入力
      # 「登録」ボタンを押すとユーザーモデルのカウントが変化していないのを確認
      # 新規登録ページへ戻っていることを確認
    end
  end
end
