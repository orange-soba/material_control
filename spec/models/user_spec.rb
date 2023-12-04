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
      end
      it 'emailが空だと登録できない' do
      end
      it 'すでに登録済みのemailだと登録できない' do
      end
      it 'emailに@が含まれていないと登録できない' do
      end
      it 'passwordが空だと登録できない' do
      end
      it 'password_confirmationが空だと登録できない' do
      end
      it 'passwordとpassword_confirmationが一致しないと登録できない' do
      end
      it 'passwordが6文字以上でないと登録できない' do
      end
      it 'passwordが英字のみだと登録できない' do
      end
      it 'passwordが数字のみだと登録できない' do
      end
      it 'passwordに英数字以外の文字が含まれていると登録できない' do
      end
    end
  end
end
