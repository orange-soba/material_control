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
      sign_in_basic(root_path)
      # 「新規登録」ボタンの確認
      expect(page).to have_content('新規登録')
      # 新規登録ページへ遷移
      visit new_user_registration_path
      # 誤ったユーザー情報の入力
      fill_in '名前', with: ''
      fill_in 'Eメール', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード（確認用）', with: ''
      # 「登録」ボタンを押すとユーザーモデルのカウントが変化していないのを確認
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { User.count }.by(0)
      # 新規登録ページへ戻っていることを確認
      expect(current_path).to eq new_user_registration_path
    end
  end
end

RSpec.describe 'ログイン、ログアウト', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインできる場合' do
    it '正しい情報を入力すればログインできて、マイページへ遷移する場合' do
      # BASIC認証を通過しトップページへ遷移
      sign_in_basic(root_path)
      # 「ログイン」ボタンの確認
      expect(page).to have_content('ログイン')
      # ログインページへ遷移
      visit new_user_session_path
      # 正しいユーザー情報の入力
      fill_in 'Eメール', with: @user.email
      fill_in 'パスワード', with: @user.password
      # 「ログイン」ボタンを押す
      find('input[name="commit"]').click
      sleep 1
      # マイページへ遷移することを確認
      expect(current_path).to eq user_path(@user)
      # ヘッダーに「ログアウト」ボタンがあるのを確認
      expect(page).to have_content('ログアウト')
      # 「新規登録」、「ログイン」ボタンがないのを確認
      expect(page).to have_no_content('新規登録')
      expect(page).to have_no_content('ログイン')
    end
  end
  context 'ログインできない場合' do
    it '誤った情報を入力するとログインできず、ログインページへ戻る場合' do
      # BASIC認証を通過しトップページへ遷移
      sign_in_basic(root_path)
      # 「ログイン」ボタンの確認
      expect(page).to have_content('ログイン')
      # ログインページへ遷移
      visit new_user_session_path
      # 誤ったユーザー情報の入力
      fill_in 'Eメール', with: ''
      fill_in 'パスワード', with: ''
      # 「ログイン」ボタンを押す
      find('input[name="commit"]').click
      # ログインページへ戻ることを確認
      expect(current_path).to eq new_user_session_path
    end
  end
  context 'ログアウトできる場合' do
    it 'ログインした状態でログアウトボタンを押せばログアウトできる' do
      # BASIC認証を通過しトップページへ遷移
      sign_in_basic(root_path)
      # ログイン
      sign_in(@user)
      # 「ログアウト」ボタンの確認
      expect(page).to have_content('ログアウト')
      # 「ログアウト」ボタンを押す
      find_link('ログアウト').click
      sleep 1
      # トップページへ遷移するのを確認
      expect(current_path).to eq root_path
      # 「新規登録」、「ログイン」ボタンがあるのを確認
      expect(page).to have_content('新規登録')
      expect(page).to have_content('ログイン')
      # 「ログアウトボタンがないのを確認」
      expect(page).to have_no_content('ログアウト')
    end
  end
end