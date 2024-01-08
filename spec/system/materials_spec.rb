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
    @material = FactoryBot.create(:material, user_id: @user.id, stock: 1.5)
  end

  context '材料の編集ができる場合' do
    it '材料一覧ページで、正しい情報を入力すれば在庫の更新ができる' do
      # ログイン
      sign_in(@user)
      # マイページに材料一覧ページへのリンクがあるのを確認
      href = 'a[href="/materials"]'
      expect(page).to have_css(href)
      # 「材料一覧」をクリックして材料一覧ページへ遷移する
      find(href).click
      sleep 1
      # 在庫数が入力済みなのを確認
      expect(find_field('material_stock').value).to eq @material.stock.to_s
      # 正しい情報を入力
      new_stock = 2.5
      fill_in 'material_stock', with: new_stock
      # 「更新」をクリックする
      find('div.history-area').find('input[name="commit"]').click
      sleep 1
      # 以前の在庫数がなく、編集後の在庫数が入力されているのを確認
      expect(find_field('material_stock').value).not_to eq @material.stock.to_s
      expect(find_field('material_stock').value).to eq new_stock.to_s
    end
    it '材料一覧ページから、編集ページに遷移し、正しい情報を入力すれば編集できる' do
      # ログイン
      sign_in(@user)
      # マイページに材料一覧ページへのリンクがあるのを確認
      href = 'a[href="/materials"]'
      expect(page).to have_css(href)
      # 「材料一覧」をクリックして材料一覧ページへ遷移する
      find(href).click
      sleep 1
      # 材料の編集ボタンをクリックして編集ページへ遷移
      href = 'a[href="/materials/' + @material.id.to_s + '/edit"]'
      find(href).click
      sleep 1
      # 情報が入力済みなのを確認
      expect(page).to have_field '　　　材質：', with: @material.material_type
      expect(page).to have_field '　　　種類：', with: @material.category
      expect(page).to have_field '厚さ(mm)：', with: @material.thickness
      expect(page).to have_field '　 幅(mm)：', with: @material.width
      expect(page).to have_field '　　その他：', with: @material.option
      expect(page).to have_field '長さ(mm)：', with: @material.length
      expect(page).to have_field '在庫数(個)：', with: @material.stock
      # 正しい情報を入力
      new_material_type = 'NewMaterial'
      fill_in '　　　材質：', with: new_material_type
      # 「更新」をクリックする
      click_on '更新'
      sleep 1

      expect(current_path).to eq materials_path
      # 以前の情報ではなく編集後の情報が表示されているのを確認
      new_material = Material.last
      expect(page).not_to have_selector('table tr:nth-child(1)', text: @material.display_combine)
      expect(page).to have_selector('table tr:nth-child(1)', text: new_material.display_combine)
    end
  end
  context '材料の編集ができない場合' do
    it 'ログインしていないと材料の編集ページへ遷移できない' do
      # BASIC認証を通過してトップページへ遷移
      sign_in_basic(root_path)
      # 材料の編集ページへ遷移
      visit edit_material_path(@material)
      # ログインページへ遷移しているのを確認
      expect(current_path).to eq new_user_session_path
    end
    it '材料一覧ページで、誤った情報を入力すると在庫の更新ができない' do
      # ログイン
      sign_in(@user)
      # マイページに材料一覧ページへのリンクがあるのを確認
      href = 'a[href="/materials"]'
      expect(page).to have_css(href)
      # 「材料一覧」をクリックして材料一覧ページへ遷移する
      find(href).click
      sleep 1
      # 在庫数が入力済みなのを確認
      expect(find_field('material_stock').value).to eq @material.stock.to_s
      # 誤った情報を入力
      new_stock = -1
      fill_in 'material_stock', with: new_stock
      # 「更新」をクリックする
      find('div.history-area').find('input[name="commit"]').click
      sleep 1
      # 在庫数が以前の情報のままで変化がないのを確認
      expect(find_field('material_stock').value).to eq @material.stock.to_s
      expect(find_field('material_stock').value).not_to eq new_stock.to_s
    end
    it '材料一覧ページから、編集ページに遷移し、誤った情報を入力すると編集できない' do
      # ログイン
      sign_in(@user)
      # マイページに材料一覧ページへのリンクがあるのを確認
      href = 'a[href="/materials"]'
      expect(page).to have_css(href)
      # 「材料一覧」をクリックして材料一覧ページへ遷移する
      find(href).click
      sleep 1
      # 材料の編集ボタンをクリックして編集ページへ遷移
      href = 'a[href="/materials/' + @material.id.to_s + '/edit"]'
      find(href).click
      sleep 1
      # 情報が入力済みなのを確認
      expect(page).to have_field '　　　材質：', with: @material.material_type
      expect(page).to have_field '　　　種類：', with: @material.category
      expect(page).to have_field '厚さ(mm)：', with: @material.thickness
      expect(page).to have_field '　 幅(mm)：', with: @material.width
      expect(page).to have_field '　　その他：', with: @material.option
      expect(page).to have_field '長さ(mm)：', with: @material.length
      expect(page).to have_field '在庫数(個)：', with: @material.stock
      # 誤った情報を入力
      new_material_type = ''
      fill_in '　　　材質：', with: new_material_type
      # 「更新」をクリックする
      click_on '更新'
      sleep 1
      # 材料の編集ページへ戻っているのを確認
      expect(current_path).to eq edit_material_path(@material)
    end
  end
end

RSpec.describe '材料の削除', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @material = FactoryBot.create(:material, user_id: @user.id)
  end
  context '材料の削除ができる場合' do
    it '材料の一覧ページの「削除」ボタンをクリックし、アラート表示の「OK」をクリックすれば削除ができる' do
      # ログイン
      sign_in(@user)
      # マイページに材料一覧ページへのリンクがあるのを確認
      href = 'a[href="/materials"]'
      expect(page).to have_css(href)
      # 「材料一覧」をクリックして材料一覧ページへ遷移する
      find(href).click
      sleep 1
      # 登録済みの材料が表示されているのを確認
      expect(page).to have_content(@material.display_combine)
      # 登録済みの材料の削除ボタンが表示されているのを確認
      href = 'a[href="/materials/' + @material.id.to_s + '"]'
      expect(page).to have_css(href)
      # 登録済みの材料の「削除」ボタンをクリックし、アラートの「OK」をクリックすると、Materialモデルのカウントが1減るのを確認
      expect{
        find(href).click
        sleep 1
        message = '「' + @material.display_combine + '」を削除してもよろしいですか？'
        expect(accept_confirm).to eq message
        sleep 1
      }.to change { Material.count }.by(-1)
      # 材料一覧に削除した材料の情報が表示されていないのを確認
      expect(page).to have_no_content(@material.display_combine)
    end
    it '材料登録ページの登録履歴の「削除」ボタンをクリックし、アラート表示の「OK」をクリックすれば削除できる' do
      # ログイン
      sign_in(@user)
      # 材料登録ページへ遷移
      visit new_material_path
      # 登録履歴に登録済みの材料が表示されているのを確認
      expect(page).to have_css('div.history-area') do |div|
        expect(div).to have_content(@material.display_combine)
      end
      # 登録済みの材料の削除ボタンが表示されているのを確認
      href = 'a[href="/materials/' + @material.id.to_s + '?now=new"]'
      expect(page).to have_css(href)
      # 登録済みの材料の「削除」ボタンをクリックし、アラートの「OK」をクリックすると、Materialモデルのカウントが1減るのを確認
      expect{
        find(href).click
        sleep 1
        message = '「' + @material.display_combine + "」を削除してもよろしいですか？\n※履歴からの削除ではありません!!"
        expect(accept_confirm).to eq message
        sleep 1
      }.to change { Material.count }.by(-1)
      # 登録履歴に削除した材料の情報が表示されていないのを確認
      expect(page).to have_css('div.history-area') do |div|
        expect(div).to have_no_content(@material.display_combine)
      end
    end
  end
end

RSpec.describe '必要材料の登録', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @part = FactoryBot.create(:part, user_id: @user.id)
    @material = FactoryBot.create(:material, user_id: @user.id)
  end
  context '必要材料の登録ができる場合' do
    it '正しい情報を入力すれば必要材料の登録をできる' do
      # ログイン
      sign_in(@user)
      # 「部品」をクリックして折りたたみ要素を開く
      find('details.parts-details').find('summary').click
      sleep 1
      # 登録済みの@partの名前をクリックして詳細ページへ遷移する
      find_link(@part.name).click
      sleep 1
      # 「材料登録」ボタンが表示されているのを確認
      href = 'a[href="/parts/' + @part.id.to_s + '/need_materials/new"]'
      expect(page).to have_css(href)
      # 「材料登録」ボタンをクリックして、必要材料登録ページへ遷移しているのを確認
      find(href).click
      sleep 1

      expect(current_path).to eq new_part_need_materials_path(@part)
      # 正しい情報を入力
      option = 'option[value="' + @material.material_id.to_s + '"]'
      num = rand(1..10)
      necessary_nums = rand(1..10)
      find('select.parts-relation__input').find(option).select_option
      fill_in '　　必要な長さ(mm)：', with: num
      fill_in '　　　　　必要数(個)：', with: necessary_nums
      # 登録ボタンをクリックすると、NeedMaterialモデルのカウントが1上がるのを確認
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { NeedMaterial.count }.by(1)
      # 登録履歴に登録した情報が表示されているのを確認
      expect(page).to have_css('div.history-area') do |div|
        expect(div).to have_content(@part.name)
        expect(div).to have_content(@material.display_combine)
        expect(div).to have_content(num)
        expect(div).to have_content(necessary_nums)
      end
      # @partの詳細ページへ遷移
      visit part_path(@part)
      # 必要な材料の一覧に登録した情報が表示されているのを確認
      expect(page).to have_css('div.need-materials') do |div|
        expect(div).to have_content(@material.display_combine)
        expect(div).to have_field('need_material_length', with: num * 1.0)
        expect(div).to have_field('need_material_necessary_nums', with: necessary_nums)
      end
    end
  end
  context '必要材料の登録ができない場合' do
    it 'ログインしていないと必要材料の登録ページへ遷移できない' do
      # BASIC認証を通過してトップページへ遷移
      sign_in_basic(root_path)
      # 必要材料の登録ページへ遷移
      visit new_part_need_materials_path(@part)
      # ログインページへ遷移しているのを確認
      expect(current_path).to eq new_user_session_path
    end
    it '誤った情報を入力すると必要材料の登録ができない' do
      # ログイン
      sign_in(@user)
      # 「部品」をクリックして折りたたみ要素を開く
      find('details.parts-details').find('summary').click
      sleep 1
      # 登録済みの@partの名前をクリックして詳細ページへ遷移する
      find_link(@part.name).click
      sleep 1
      # 「材料登録」ボタンが表示されているのを確認
      href = 'a[href="/parts/' + @part.id.to_s + '/need_materials/new"]'
      expect(page).to have_css(href)
      # 「材料登録」ボタンをクリックして、必要材料登録ページへ遷移しているのを確認
      find(href).click
      sleep 1

      expect(current_path).to eq new_part_need_materials_path(@part)
      # 誤った情報を入力
      option = 'option[value="' + @material.material_id.to_s + '"]'
      num = 0.0
      necessary_nums = 0.0
      find('select.parts-relation__input').find(option).select_option
      fill_in '　　必要な長さ(mm)：', with: num
      fill_in '　　　　　必要数(個)：', with: necessary_nums
      # 登録ボタンをクリックしても、NeedMaterialモデルのカウントが変化していないのを確認
      expect{
        find('input[name="commit"]').click
        sleep 1
      }.to change { NeedMaterial.count }.by(0)
      # 必要材料の登録ページへ戻っているのを確認
      expect(current_path).to eq new_part_need_materials_path(@part)
    end
  end
end

RSpec.describe '必要材料の削除', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @part = FactoryBot.create(:part, user_id: @user.id)
    @material = FactoryBot.create(:material, user_id: @user.id)
    @need_material = FactoryBot.create(:need_material, part_id: @part.id, material_id: @material.material_id, user_id: @user.id)
  end
  context '必要材料の削除ができる場合' do
    it '部品詳細ページにて登録済みの必要材料の削除ができる' do
      # ログイン
      sign_in(@user)
      # 「部品」をクリックして折りたたみ要素を開く
      find('details.parts-details').find('summary').click
      sleep 1
      # 登録済みの@partの名前をクリックして詳細ページへ遷移する
      find_link(@part.name).click
      sleep 1
      # 登録済みの必要材料が表示されているのを確認
      expect(page).to have_css('div.need-materials') do |div|
        expect(div).to have_content(@material.display_combine)
        expect(div).to have_field('need_material_length', with: @need_material.length.round(2))
        expect(div).to have_field('need_material_length_option', with: @need_material.length_option.round(3))
        expect(div).to have_field('need_material_necessary_nums', with: @need_material.necessary_nums)
      end
      # 登録済みの必要材料に削除ボタンがあるのを確認
      href = 'a[href="/parts/' + @part.id.to_s + '/need_materials?material_id=' + @material.material_id.to_s + '"]'
      expect(page).to have_css(href)
      # 登録済みの必要材料の「削除」ボタンをクリックし、アラートの「OK」をクリックすると、NeedMaterialモデルのカウントが1減るのを確認
      expect{
        find(href).click
        sleep 1
        message = '「' + @material.display_combine + '」を除外してもよろしいですか？'
        expect(accept_confirm).to eq message
        sleep 1
      }.to change { NeedMaterial.count }.by(-1)
      # 部品詳細ページへ戻っているのを確認
      expect(current_path).to eq part_path(@part)
      # 部品詳細ページに削除した必要材料が表示されていないのを確認
      expect(page).to have_css('div.need-materials') do |div|
        expect(div).not_to have_content(@material.display_combine)
        expect(div).not_to have_field('need_material_length', with: @need_material.length.round(2))
        expect(div).not_to have_field('need_material_length_option', with: @need_material.length_option.round(3))
        expect(div).not_to have_field('need_material_necessary_nums', with: @need_material.necessary_nums)
      end
    end
  end
end

RSpec.describe '必要材料の編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @part = FactoryBot.create(:part, user_id: @user.id)
    @material = FactoryBot.create(:material, user_id: @user.id)
    @need_material = FactoryBot.create(:need_material, part_id: @part.id, material_id: @material.material_id, user_id: @user.id)
  end
  context '必要材料の編集ができる場合' do
    it '部品詳細ページで正しい情報を入力すれば必要材料の編集ができる' do
      # ログイン
      sign_in(@user)
      # 「部品」をクリックして折りたたみ要素を開く
      find('details.parts-details').find('summary').click
      sleep 1
      # 登録済みの@partの名前をクリックして詳細ページへ遷移する
      find_link(@part.name).click
      sleep 1
      # 登録済みの必要材料が表示されているのを確認
      expect(page).to have_css('div.need-materials') do |div|
        expect(div).to have_content(@material.display_combine)
        length = find_field('need_material_length').value.to_f.round(2)
        expect(length).to eq(@need_material.length.round(2))
        length_option = find_field('need_material_length_option').value.to_f.round(2)
        expect(length_option).to eq(@need_material.length_option.round(2))
        expect(div).to have_field('need_material_necessary_nums', with: @need_material.necessary_nums)
      end
      # 正しい情報を入力
      new_length = rand(1.0..1000.0).round(2)
      fill_in 'need_material_length', with: new_length
      # 「更新」ボタンをクリック
      within '.need-material__input-length' do
        click_on '更新'
      end
      sleep 1
      # 以前の情報ではなく編集後の情報が表示されているのを確認
      expect(page).to have_css('div.need-materials') do |div|
        expect(div).not_to have_field('need_material_length', with: @need_material.length.round(2))
        expect(div).to have_field('need_material_length', with: new_length)
      end
    end
  end
  context '必要材料の編集ができない場合' do
    it '部品詳細ページで誤った情報を入力すると必要材料の編集ができない' do
      # ログイン
      sign_in(@user)
      # 「部品」をクリックして折りたたみ要素を開く
      find('details.parts-details').find('summary').click
      sleep 1
      # 登録済みの@partの名前をクリックして詳細ページへ遷移する
      find_link(@part.name).click
      sleep 1
      # 登録済みの必要材料が表示されているのを確認
      expect(page).to have_css('div.need-materials') do |div|
        expect(div).to have_content(@material.display_combine)
        length = find_field('need_material_length').value.to_f.round(2)
        expect(length).to eq(@need_material.length.round(2))
        length_option = find_field('need_material_length_option').value.to_f.round(2)
        expect(length_option).to eq(@need_material.length_option.round(2))
        expect(div).to have_field('need_material_necessary_nums', with: @need_material.necessary_nums)
      end
      # 誤った情報を入力
      new_length = 0
      fill_in 'need_material_length', with: new_length
      # 「更新」ボタンをクリック
      within '.need-material__input-length' do
        click_on '更新'
      end
      sleep 1
      # 表示されている情報が変化のないのを確認
      expect(page).to have_css('div.need-materials') do |div|
        expect(div).to have_field('need_material_length', with: @need_material.length.round(2))
        expect(div).not_to have_field('need_material_length', with: new_length)
      end
    end
  end
end