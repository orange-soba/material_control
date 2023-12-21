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
      sign_in_basic(root_path)
      # 編集ページへ遷移
      visit edit_part_path(@part)
      # ログインページへ遷移しているのを確認
      expect(current_path).to eq new_user_session_path
    end
  end
end

RSpec.describe '完成品/部品の削除', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @part = FactoryBot.create(:part, user_id: @user.id)
  end
  context '削除できる時' do
    it '部品詳細ページの削除ボタンを押し、アラート表示の「OK」をクリックすれば削除できる' do
      # ログイン
      sign_in(@user)
      # 「部品」をクリックし、折りたたみ要素を開く
      find('details.parts-details').find('summary').click
      sleep 1
      # 部品名をクリックし、部品詳細ページへ遷移
      find_link(@part.name).click
      sleep 1

      expect(current_path).to eq part_path(@part)
      # 「削除」ボタンを確認
      expect(page).to have_content('削除')
      # 「削除」ボタンをクリックし、アラートの「OK」をクリックすると、Partモデルのカウントが1減るのを確認
      expect{
        find('div.part-show').find_link('削除').click
        sleep 1
        message = '「' + @part.name + '」を削除してもよろしいですか？'
        expect(page.accept_confirm).to eq message
        sleep 1
      }.to change { Part.count }.by(-1)
      # マイページへ遷移しているのを確認
      expect(current_path).to eq user_path(@user)
      # 「部品」をクリックし折りたたみ要素を開き、削除した部品名がないのを確認
      find('details.parts-details').find('summary').click
      sleep 1

      expect(page).to have_no_content(@part.name)
    end
    it '新規登録ページの履歴において削除ボタンを押し、アラート表示の「OK」をクリックすれば削除できる' do
      # ログイン
      sign_in(@user)
      # 部品の新規登録ページへ遷移
      visit new_part_path
      # 履歴に部品の登録があるのを確認(名前)
      expect(page).to have_content(@part.name)
      # 履歴に「削除」ボタンがあるのを確認
      href = 'a[href="/parts/' + @part.id.to_s + '?now=new"]'
      expect(page).to have_css(href)
      # 「削除」ボタンをクリックし、アラートの「OK」をクリックすると、Partモデルのカウントが1減るのを確認
      expect{
        find(href).click
        sleep 1
        message = '「' + @part.name + "」を削除してもよろしいですか？\n※履歴からの削除ではありません!!"
        expect(accept_confirm).to eq message
        sleep 1
    }.to change { Part.count }.by(-1)
      sleep 1
      # 新規登録ページへ戻るのを確認
      expect(current_path).to eq new_part_path
      # 履歴に削除した部品の名前がないのを確認
      expect(page).to have_no_content(@part.name)
    end
  end
end

RSpec.describe '必要部品の登録', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @parent = FactoryBot.create(:part, user_id: @user.id, finished: true)
    @child = FactoryBot.create(:part, user_id: @user.id)
  end
  context '登録できる場合' do
    it '部品を必要な部品として登録出来る' do
      # ログイン
      sign_in(@user)
      # 「完成品」をクリックして折りたたみ要素を開く
      find('details.products-details').find('summary').click
      sleep 1
      # 登録済みの@parentの名前をクリックして詳細ページへ遷移する
      find_link(@parent.name).click
      sleep 1

      expect(current_path).to eq part_path(@parent)
      # 「部品登録」ボタンを確認
      href = 'a[href="/parts/' + @parent.id.to_s + '/parts_relations/new"]'
      expect(page).to have_css(href)
      # 「部品登録」ボタンをクリックし、必要部品登録ページへ遷移するのを確認
      find(href).click
      sleep 1

      expect(current_path).to eq new_part_parts_relations_path(@parent)
      # セレクトボックスから@childの名前を選択し、必要数を入力する
      option = 'option[value="' + @child.id.to_s + '"]'
      num = rand(10)
      find('select.parts-relation__input').find(option).select_option
      fill_in '　　　必要数：', with: num
      # 「登録」ボタンをクリックし、Parts_relationモデルのカウントが1上がるのを確認
      expect{
        click_on '登録'
        sleep 1
      }.to change { PartsRelation.count }.by(1)
      # 登録履歴に登録した情報が表示されているのを確認
      expect(page).to have_selector('table tr:nth-child(1)', text: @parent.name)
      expect(page).to have_selector('table tr:nth-child(1)', text: @child.name)
      expect(page).to have_selector('table tr:nth-child(1)', text: num)
      # 部品詳細ページ(@parent)に遷移し、必要登録した部品の名前と必要数が表示されているか確認
      visit part_path(@parent)
      sleep 1

      expect(page).to have_selector('div.need-parts table tr:nth-child(1)', text: @child.name)
      expect(page).to have_selector('div.need-parts table tr:nth-child(1)', text: num)
    end
  end
  context '登録できない場合' do
    it 'ログインしていないと必要部品の新規登録ページへ遷移できない' do
      # BASIC認証を通過しトップページへ遷移
      sign_in_basic(root_path)
      # 必要部品登録ページへ遷移
      visit new_part_parts_relations_path(@parent)
      # ログインページへ遷移しているのを確認
      expect(current_path).to eq new_user_session_path
    end
    it '完成品は必要な部品として登録できない' do
      # ログイン
      # 「部品」をクリックして折りたたみ要素を開く
      # 登録済みの@childの名前をクリックして詳細ページへ遷移する
      # 「部品登録」ボタンをクリックし、必要部品登録ページへ遷移するのを確認
      # セレクトボックスから@parentの名前を選択し、必要数を入力する
      # 「登録」ボタンをクリックしても、Parts_relationモデルのカウントが変化しないのを確認
    end
    it 'A=>B=>Cという親子親子関係ができている時、新たにC=>Aという登録はできない' do
      # @parentのfinishedをfalseにupdateし、また部品Cを作成し、A=>B=>Cという親子関係を作成する
      # A: @parent, B: @child, C: @c_partとして扱う
      # ログイン
      # 「部品」をクリックして折りたたみ要素を開く
      # 登録済みの部品Cの名前をクリックして詳細ページへ遷移する
      # 「部品登録」ボタンをクリックし、必要部品登録ページへ遷移するのを確認
      # セレクトボックスから部品Aの名前を選択し、必要数を入力する
      # 「登録」ボタンをクリックしても、Parts_relationモデルのカウントが変化しないのを確認
    end
    it 'A=>Bという登録があるときにまたA=>Bという登録はできない' do
      # @parentに@childを必要部品として登録する
      # ログイン
      # 「部品」をクリックして折りたたみ要素を開く
      # 登録済みの@parentの名前をクリックして詳細ページへ遷移する
      # 「部品登録」ボタンをクリックし、必要部品登録ページへ遷移するのを確認
      # セレクトボックスから@childの名前を選択し、必要数を入力する
      # 「登録」ボタンをクリックしても、Parts_relationモデルのカウントが変化しないのを確認
    end
  end
end