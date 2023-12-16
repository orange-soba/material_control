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
    it '正しい情報を入力すればログインできて、マイページへ遷移する' do
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
    it '誤った情報を入力するとログインできず、ログインページへ戻る' do
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

RSpec.describe '編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ユーザー情報の編集ができる場合' do
    it '自分のユーザー情報の編集ができる(名前)' do
      # ログイン
      # 編集リンクを確認
      # 編集リンクへカーソルを合わせると「ユーザーの編集」と表示されるのを確認
      # 編集リンクをクリック
      # 編集ページへ遷移するのを確認
      # ユーザー情報がすでに入力済みなのを確認
      # ユーザー情報(名前)を編集し、現在のパスワードを入力
      # 編集してもユーザーモデルのカウントは変化しないのを確認
      # マイページへ遷移しているのを確認
      # 表示されている名前が編集した名前になっているのを確認
      # 以前の名前が表示されていないのを確認
    end
    it '自分のユーザー情報が編集できる(Eメール)' do
      # ログイン
      # 編集リンクを確認
      # 編集リンクへカーソルを合わせると「ユーザーの編集」と表示されるのを確認
      # 編集リンクをクリック
      # 編集ページへ遷移するのを確認
      # ユーザー情報がすでに入力済みなのを確認
      # ユーザー情報(名前)を編集し、現在のパスワードを入力
      # 編集してもユーザーモデルのカウントは変化しないのを確認
      # マイページへ遷移しているのを確認
      # ログアウト
      # ログインする際に以前のEメールでへログインできず、ログインページに戻るのを確認
      # 編集後のEメールを入力するとログインできるのを確認
    end
  end
  context 'ユーザー情報の編集ができない場合' do
    it 'ログインしていないユーザーは編集ページに遷移できずに、ログインページへ遷移する' do
      # 編集ページへ遷移する
      # ログインページへ遷移しているのを確認
    end
    it '名前やEメールが空白だと編集できずに、編集ページに戻る' do
      # ログイン
      # 編集ページへ遷移
      # 名前とEメールを空白にし、他には正しい情報を入力する
      # 更新ボタンをクリック
      # マイページへ遷移しておらず、編集ページへ戻るのを確認
    end
    it '現在のパスワードが空白だと編集できない' do
      # ログイン
      # 編集ページへ遷移
      # パスワードが空白なのを確認
      # 更新ボタンをクリック
      # マイページへ遷移しておらず、編集ページへ戻るのを確認
    end
    it '新しいパスワードと確認用パスワードが違うと編集できない' do
      # ログイン
      # 編集ページへ遷移
      # 新しいパスワードと確認用パスワードを違うものを入力し、他には正しい情報を入力
      # 更新ボタンをクリック
      # マイページへ遷移しておらず、編集ページへ戻るのを確認
    end
  end
end