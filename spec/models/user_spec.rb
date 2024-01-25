require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できる場合' do
      it '必要な情報が揃っていれば登録できる' do
        expect(@user).to be_valid
      end
    end

    context '新規登録できない場合' do
      it 'nameが空だと登録できない' do
        @user.name = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('名前を入力してください')
      end
      it 'emailが空だと登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールを入力してください')
      end
      it 'すでに登録済みのemailだと登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include('Eメールはすでに存在します')
      end
      it 'emailに@が含まれていないと登録できない' do
        @user.email = 'test.com'
        @user.valid?
        expect(@user.errors.full_messages).to include('Eメールは不正な値です')
      end
      it 'passwordが空だと登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードを入力してください')
        expect(@user.errors.full_messages).to include('パスワードは半角英数字（6文字以上）での入力が必須です')
      end
      it 'password_confirmationが空だと登録できない' do
        @user.password_confirmation = ''
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
      it 'passwordとpassword_confirmationが一致しないと登録できない' do
        @user.password = 'password1'
        @user.password_confirmation = 'passw0rd1'
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワード（確認用）とパスワードの入力が一致しません')
      end
      it 'passwordが6文字以上でないと登録できない' do
        @user.password = 'pass1'
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは6文字以上で入力してください')
      end
      it 'passwordが英字のみだと登録できない' do
        @user.password = 'password'
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは半角英数字（6文字以上）での入力が必須です')
      end
      it 'passwordが数字のみだと登録できない' do
        @user.password = '1234567890'
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは半角英数字（6文字以上）での入力が必須です')
      end
      it 'passwordに英数字以外の文字が含まれていると登録できない' do
        @user.password = 'password1パス'
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include('パスワードは半角英数字（6文字以上）での入力が必須です')
      end
      it 'post_codeが空だと登録できない' do
      end
      it 'prefecture_idが空だと登録できない' do
      end
      it 'prefecture_idが文字列だと登録できない' do
      end
      it 'prefecture_idが0以下だと登録できない' do
      end
      it 'prefecture_idが48以上だと登録できない' do
      end
      it 'cityが空だと登録できない' do
      end
      it 'house_numberが空だと登録できない' do
      end
      it 'phone_numberが空だと登録できない' do
      end
    end
  end
end
