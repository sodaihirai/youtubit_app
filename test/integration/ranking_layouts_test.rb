require 'test_helper'

class RankingLayoutsTest < ActionDispatch::IntegrationTest
 
def setup
 @user = users(:Taro)
 @first_title = "the journey of paris"
 @second_title = "good"
 @third_title_one = "hungry"
 @third_title_second = "sleepy"
 @fourth_title = "angry"
 log_in_as(@user)
end
 
test "video title ranking layout" do
	get root_path
	assert_match @first_title, response.body
	assert_match @second_title, response.body
	assert_match @third_title_one, response.body
	assert_match @third_title_second, response.body
	#assert_no_match @fourth_title, response.body
end

test "like micropost ranking layout" do
	get root_path
	assert_select 'a[href=?]', micropost_path(microposts(:nice))
	assert_select 'a[href=?]', micropost_path(microposts(:good))
	#assert_select 'a[href=?]', micropost_path(microposts(:hungry))
	#assert_select 'a[href=?]', micropost_path(microposts(:hungry2))
	assert_select 'a[href=?]', micropost_path(microposts(:sleepy)), count: 0
end

test "follower ranking layout" do
	get root_path
	assert_select 'a[href=?]',    user_path(users(:Hanako))
	assert_select 'a[href=?]',    user_path(users(:Taro))
	#assert_select 'a[href=?]',    user_path(users(:Kazuo)) 
	#assert_select 'a[href=?]', 	  user_path(users(:Takuya))
	assert_select 'a[href=?]', 	  user_path(users(:Yurie)), count: 0 
end

end
