require 'test_helper'

class ChatSearchLayoutTest < ActionDispatch::IntegrationTest

  def setup
  	@user = users(:Taro)
  	@Hanako = users(:Hanako)
  	@Kazuo = users(:Kazuo)
  	log_in_as(@user)
  end

  test "chat search layout" do
  	get chat_index_user_path(@user)
  	assert_select 'a[href=?]', chat_user_path(@Hanako)
  	assert_select 'a[href=?]', chat_user_path(@Kazuo)
  	post chat_search_user_path(@user), params: { q: "Hanako" }
  	assert_template 'users/chat_index'
  	assert_select 'a[href=?]', chat_user_path(@Hanako)
  	assert_select 'a[href=?]', chat_user_path(@Kazuo), count: 0  	
  	post chat_search_user_path(@user), params: { q: "fdajoifjasdoifj"}
  	assert_template 'users/chat_index'
  	assert_select 'a[href=?]', chat_user_path(@Hanako), count: 0
  	assert_select 'a[href=?]', chat_user_path(@Kazuo), count: 0  	
  	post chat_search_user_path(@user), params: { q: "" }
  	assert_template 'users/chat_index'
  	assert_select 'a[href=?]', chat_user_path(@Hanako)
  	assert_select 'a[href=?]', chat_user_path(@Kazuo)	
  end

end
