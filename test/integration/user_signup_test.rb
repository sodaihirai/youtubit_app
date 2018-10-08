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

end
