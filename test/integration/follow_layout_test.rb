require 'test_helper'

class FollowLayoutTest < ActionDispatch::IntegrationTest

	def setup
		@user   = users(:Taro)
		@hanako = users(:Hanako)
		@kazuo  = users(:Kazuo)
		@rel    = relationships(:one)
	end
  
	test "follow layout test" do
		log_in_as @user
		get user_path(@kazuo)
		assert_template 'users/show'
		post relationships_path, params: { followed_id: @kazuo.id }, xhr: true
		assert_match @kazuo.passive_relationships.count.to_s, response.body 
	end

	test "unfollow layout test" do
		log_in_as @user
		get user_path(@hanako)
		assert_template 'users/show'
		delete relationship_path(@rel), xhr: true
		assert_match @hanako.passive_relationships.count.to_s, response.body
	end
end
