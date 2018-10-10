require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "password_reset" do
  	user = users(:Taro)
  	get login_path
  	assert_select 'a[href=?]', new_password_reset_path
  	get new_password_reset_path
  	assert_template 'password_resets/new'
  	#無効なメールアドレスを送信	
  	post password_resets_path, params: { password_reset: { email: "" } }
  	assert_not flash.empty?
  	assert_template "password_resets/new"
  	#有効なメールアドレスを送信
  	post password_resets_path, params: { password_reset: { email: user.email } }
  	assert_equal 1, ActionMailer::Base.deliveries.size
  	assert_not flash.empty?
  	assert_redirected_to root_url
  	user = assigns(:user)
  	#トークンが不正
  	get edit_password_reset_path("invalid token", email: user.email)
  	assert_not flash.empty?
  	assert_redirected_to root_url
  	#メールアドレスが不正
  	get edit_password_reset_path(user.reset_token, email: "")
  	assert_redirected_to root_url
  	#メールアドレスもトークンも正しい
  	get edit_password_reset_path(user.reset_token, email: user.email)
  	assert_template 'password_resets/edit'
  	#空のパスワードを作成
  	patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: "" ,
  																						password_confirmation: "" } }
  	assert_not flash.empty?
  	assert_template 'password_resets/edit'
  	#無効なパスワードを送信
  	patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: "foo" ,
  																						password_confirmation: "bar" } }
  	assert_not flash.empty?
  	assert_template 'password_resets/edit'
  	#有効なパスワードを送信
  	valid_password = "foobar"
  	patch password_reset_path(user.reset_token), params: { email: user.email, user: { password: valid_password ,
  																						password_confirmation: valid_password } }
  	assert_not flash.empty?
  	assert is_logged_in?
  	#assert_equal valid_password, user.reload.password
  	assert_redirected_to user
  end
end
