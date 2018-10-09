require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

 def setup
 	@user = users(:Taro)
 end

 test "login with valid info and logout" do
 	get login_path
 	assert_template 'sessions/new'
 	post login_path, params: { session: { email: @user.email, password: "password" } }
 	assert is_logged_in?
 	assert_redirected_to @user
 	follow_redirect!
 	assert_select 'a[href=?]', login_path, count: 0
 	assert_select 'a[href=?]', user_path(@user)
 	assert_select 'a[href=?]', edit_user_path(@user)
 	assert_select 'a[href=?]', logout_path
 	delete logout_path
 	assert_redirected_to root_url
 	delete logout_path
 	assert_redirected_to root_url
 	follow_redirect!
 	assert_select 'a[href=?]', login_path
 	assert_select 'a[href=?]', user_path(@user), count: 0
 	assert_select 'a[href=?]', edit_user_path(@user), count: 0
 	assert_select 'a[href=?]', logout_path, count: 0
 	assert_not is_logged_in?
 end

 test "successful login with friendly forwarding" do
 	get edit_user_path(@user)
 	assert_redirected_to login_url
 	log_in_as(@user)
 	assert_redirected_to edit_user_path(@user)
 end

 test "login with remembering" do
 	log_in_as(@user, remember_me: '1')
 	assert_not_empty cookies['remember_token']
 end

 test "login without remembering" do
 	log_in_as(@user, remember_me: '1')
 	delete logout_path
 	log_in_as(@user, remember_me: '0')
 	assert_empty cookies['remember_token']
 end

end
