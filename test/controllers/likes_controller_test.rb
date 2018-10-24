require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  	
	def setup
		@user = users(:Yurie)
		@Taro = users(:Taro)
		@micropost = microposts(:good)
		@micropost_nice = microposts(:nice)
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

	test "create work" do
		log_in_as @user
		assert_difference '@micropost.likes.count', 1 do
			post likes_path, params: { micropost_id: @micropost.id }
		end
	end

	test "create work with ajax" do
		log_in_as @user
		assert_difference '@micropost.likes.count', 1 do
			post likes_path, params: { micropost_id: @micropost.id}, xhr: true
		end
	end

	test "destroy work" do
		log_in_as @Taro
		assert_difference '@micropost_nice.likes.count', -1 do
			delete like_path(@like)
		end
	end

	test "destroy work with ajax" do
		log_in_as @Taro
		assert_difference '@micropost_nice.likes.count', -1 do
			delete like_path(@like), xhr: true
		end
	end
end
