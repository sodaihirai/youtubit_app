require 'test_helper'

class ChatIndexLayoutsTest < ActionDispatch::IntegrationTest
 
 def setup
 	@taro   = users(:Taro)
 	log_in_as @taro
 	@hanako = users(:Hanako)
 	@kazuo  = users(:Kazuo)
 	@one    = messages(:one)
 	@two    = messages(:two)
 	@three  = messages(:three)
 	@four   = messages(:four)
 	@five   = messages(:five)
 	@six    = messages(:six)
 end

 test "chat idnex layout" do
 	get chat_index_user_path(@taro)
 	assert_template 'users/chat_index'
 	assert_select 'a[href=?]', chat_user_path(@hanako)
 	assert_select 'a[href=?]', chat_user_path(@kazuo)
 end

end
