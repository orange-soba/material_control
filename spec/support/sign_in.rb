module SignIn
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    find('input[name="commit"]').click
    sleep 1
    expect(current_path).to eq user_path(user)
  end
end