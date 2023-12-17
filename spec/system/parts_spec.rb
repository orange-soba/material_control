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
      # BSIC認証を通過してトップページへ遷移
      sign_in_basic(root_path)
      # 新規登録ページへ遷移
      visit new_part_path
      # ログインページへ遷移しているのを確認
      expect(current_path).to eq new_user_session_path
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
    @part = FactoryBot.create(:part, user_id: @user.id, stock: 0)
  end

  context '編集ができる場合' do
    it '部品詳細ページで在庫数の編集ができる' do
      # ログイン
      sign_in(@user)
      # マイページへ遷移しているのを確認
      expect(current_path).to eq user_path(@user)
      # 登録済みの部品の名前がまだないのを確認
      expect(page).to have_no_content @part.name
      # 「部品」をクリックして折りたたみ要素を開く
      find('details.parts-details').find('summary').click
      sleep 1
      # 登録済みの部品の名前があるのを確認
      expect(page).to have_content @part.name
      # 部品名をクリックし、部品詳細ページへ遷移しているのを確認
      find_link(@part.name).click
      sleep 1

      expect(current_path).to eq part_path(@part)
      # 在庫欄に現在の在庫数が入力されているのを確認
      expect(page).to have_field('part_stock', with: @part.stock)
      # 在庫の数値を変更する
      new_stock = 1
      fill_in 'part_stock', with: new_stock
      # 「更新」ボタンをクリック
      click_on '更新'
      sleep 1
      # 入力済みの在庫数が変更されているのを確認
      expect(page).to have_field('part_stock', with: new_stock)
    end
    it '部品詳細ページから編集ページに遷移して情報の編集ができる' do
      # ログイン
      sign_in(@user)
      # マイページへ遷移しているのを確認
      expect(current_path).to eq user_path(@user)
      # 登録済みの部品の名前がまだないのを確認
      expect(page).to have_no_content @part.name
      # 「部品」をクリックして折りたたみ要素を開く
      find('details.parts-details').find('summary').click
      sleep 1
      # 登録済みの部品の名前があるのを確認
      expect(page).to have_content @part.name
      # 部品名をクリックし、部品詳細ページへ遷移しているのを確認
      find_link(@part.name).click
      sleep 1
      
      expect(current_path).to eq part_path(@part)
      # 編集ボタンを確認
      expect(page).to have_content('編集')
      # 編集ボタンをクリックして、編集ページへ遷移するのを確認
      click_on '編集'
      sleep 1

      expect(current_path).to eq edit_part_path(@part)
      # 部品情報がすでに入力済みなのを確認
      expect(page).to have_field '完成品名/部品名：', with: @part.name
      expect(page).to have_field '在庫数：', with: @part.stock
      # 名前を編集(確認用)
      new_name = @part.name.reverse
      fill_in '完成品名/部品名：', with: new_name
      # 更新ボタンをクリックし、部品詳細ページへ遷移するのを確認
      click_on '更新'
      sleep 1

      expect(current_path).to eq part_path(@part)
      # 以前の部品名がなく、編集後の部品名があるのを確認
      expect(page).to have_no_content(@part.name)
      expect(page).to have_content(new_name)
    end
  end
  context '編集ができない場合' do
    it 'ログインしていないと編集ページに遷移できない' do
      # BASIC認証を通過し、トップページへ遷移
      # 編集ページへ遷移
      # ログインページへ遷移しているのを確認
    end
  end
end