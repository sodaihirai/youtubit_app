require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  

  test "invalid signup should reject" do
  	get signup_path
  	assert_no_difference 'User.count' do
	  	post users_path, params: { user: { name: " ",
	  										email: " ",
	  										password: "foo",
	  									    password_confirmation: "bar" } }	
  	end
  	assert_template 'users/new'
  	assert_select 'div.error_explanation'
  end

  test "valid signup" do
  	get signup_path
  	assert_difference 'User.count', 1 do
  		post users_path, params: { user: { name: "example",
  											email: "example@example.com",
  											password: "foobar",
  											password_confirmation: "foobar" } }
  	end
    assert is_logged_in?
  	assert_not flash.empty?
  	follow_redirect!
  	assert_template 'users/show'
  end

  test "valid unsubscribe" do
    user = users(:Taro)
    log_in_as(user)
    get unsubscribe_user_path(user)
    assert_template 'users/unsubscribe'
    assert_select 'a', text: "アカウント削除"
    assert_difference 'User.count', -1 do
      delete user_path(user)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end

end
