require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

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

  test "valid signup information with accout activation" do
  	get signup_path
  	assert_difference 'User.count', 1 do
  		post users_path, params: { user: { name: "example",
                    											email: "foo@example.com",
                    											password: "foobar",
                    											password_confirmation: "foobar" } }
  	end
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    user = assigns(:user)
    assert_not user.activated?
    #無効なトークンを送信
    get edit_account_activation_path("invalid_token", email: user.email)
    assert_not user.reload.activated?
    assert_not flash.empty?
    assert_redirected_to root_url
    #無効なメールアドレスを送信
    get edit_account_activation_path(user.activation_token, email: " ")
    assert_not user.reload.activated?
    assert_not flash.empty?
    assert_redirected_to root_url
    #有効なトークンと有効なメールアドレスを送信
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    assert_not flash.empty?
    assert_redirected_to user
    assert is_logged_in?
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
