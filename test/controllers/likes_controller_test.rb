require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  	
	def setup
		@micropost = microposts(:good)
		@like = likes(:one)
	end

	test "create should redirect when not logged in" do
		assert_no_difference '@micropost.likes.count' do
			post likes_path, params: { micropost_id: @micropost.id }
		end
		assert_redirected_to login_url
	end

	test "destroy should redirect when not logged in" do
		assert_no_difference '@micropost.likes.count' do
			delete like_path(@like)
		end
		assert_redirected_to login_url
	end
end
