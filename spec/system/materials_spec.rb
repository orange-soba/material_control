require 'rails_helper'

RSpec.describe "材料の新規登録", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @material = FactoryBot.build(:material)
  end

  context '材料の新規登録ができる場合' do
    it '正しい情報を入力すれば材料の新規登録ができ、登録履歴に入力した情報が表示される' do
      # ログイン
      sign_in(@user)
      # ヘッダーに「材料登録」があるのを確認
      expect(page).to have_css('div.header') do |div|
        expect(div).to have_content('材料登録')
      end
      # 「材料登録」をクリックして新規登録ページへ遷移
      click_on '材料登録'
      sleep 1
      # 正しい情報を入力
      fill_in '　　　材質：', with: @material.material_type
      fill_in '　　　種類：', with: @material.category
      fill_in '厚さ(mm)：', with: @material.thickness
      fill_in '　 幅(mm)：', with: @material.width
      fill_in '　　その他：', with: @material.option
      fill_in '長さ(mm)：', with: @material.length
      fill_in '在庫数(個)：', with: @material.stock
      # 「登録」をクリックするとMaterialモデルのカウントが１上がるのを確認
      expect{
        click_on '登録'
        sleep 1
      }.to change { Material.count }.by(1)
      # 登録履歴に先ほど登録した情報が表示されているのを確認
      expect(page).to have_selector('table tr:nth-child(1)', text: @material.display_combine)
      expect(page).to have_selector('table tr:nth-child(1)', text: @material.length)
      expect(page).to have_selector('table tr:nth-child(1)', text: @material.stock)
    end
  end
  context '材料の新規登録ができない場合' do
    it 'ログインしていないと材料の新規ページへ遷移できない' do
      # BASIC認証を通過してトップページへ遷移
      sign_in_basic(root_path)
      # ヘッダーに「材料登録」がないのを確認
      expect(page).to have_css('div.header') do |div|
        expect(div).to have_no_content('材料登録')
      end
      # 材料の新規ページへ遷移
      visit new_material_path
      sleep 1
      # ログインページへ遷移しているのを確認
      expect(current_path).to eq new_user_session_path
    end
    it '誤った情報を入力すると新規登録ができず、新規登録ページへ戻ってくる' do
      # ログイン
      sign_in(@user)
      # ヘッダーに「材料登録」があるのを確認
      expect(page).to have_css('div.header') do |div|
        expect(div).to have_content('材料登録')
      end
      # 「材料登録」をクリックして新規登録ページへ遷移
      click_on '材料登録'
      sleep 1
      # 誤った情報を入力
      fill_in '　　　材質：', with: ''
      fill_in '　　　種類：', with: ''
      fill_in '厚さ(mm)：', with: ''
      fill_in '長さ(mm)：', with: ''
      fill_in '在庫数(個)：', with: ''
      # 「登録」をクリックしてもMaterialモデルのカウントが変化していないのを確認
      expect{
        click_on '登録'
        sleep 1
      }.to change { Material.count }.by(0)
      # 新規登録ページへ戻っているのを確認
      expect(current_path).to eq new_material_path
    end
  end
end


RSpec.describe '材料の編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @material = FactoryBot.create(:user, user_id: @user.id)
  end

  context '材料の編集ができる場合' do
    it '材料一覧ページで、正しい情報を入力すれば在庫の更新ができる' do
      # ログイン
      # マイページに材料一覧ページへのリンクがあるのを確認
      # 「材料一覧」をクリックして材料一覧ページへ遷移する
      # 在庫数が入力済みなのを確認
      # 正しい情報を入力
      # 「更新」をクリックする
      # 以前の在庫数がなく、編集後の在庫数が入力されているのを確認
    end
    it '材料一覧ページから、編集ページに遷移し、正しい情報を入力すれば編集できる' do
      # ログイン
      # マイページに材料一覧ページへのリンクがあるのを確認
      # 「材料一覧」をクリックして材料一覧ページへ遷移する
      # 材料の編集ボタンをクリックして編集ページへ遷移
      # 情報が入力済みなのを確認
      # 正しい情報を入力
      # 「更新」をクリックする
      # 以前の情報ではなく編集後の情報が表示されているのを確認
    end
  end
  context '材料の編集ができない場合' do
    it 'ログインしていないと材料の編集ページへ遷移できない' do
      # BASIC認証を通過してトップページへ遷移
      # 材料の編集ページへ遷移
      # ログインページへ遷移しているのを確認
    end
    it '材料一覧ページで、誤った情報を入力すると在庫の更新ができない' do
      # ログイン
      # マイページに材料一覧ページへのリンクがあるのを確認
      # 「材料一覧」をクリックして材料一覧ページへ遷移する
      # 在庫数が入力済みなのを確認
      # 誤った情報を入力
      # 「更新」をクリックする
      # 在庫数が以前の情報のままで変化がないのを確認
    end
    it '材料一覧ページから、編集ページに遷移し、誤った情報を入力すると編集できない' do
      # ログイン
      # マイページに材料一覧ページへのリンクがあるのを確認
      # 「材料一覧」をクリックして材料一覧ページへ遷移する
      # 材料の編集ボタンをクリックして編集ページへ遷移
      # 情報が入力済みなのを確認
      # 誤った情報を入力
      # 「更新」をクリックする
      # 材料の編集ページへ戻っているのを確認
    end
  end
end