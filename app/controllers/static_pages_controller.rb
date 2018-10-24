class StaticPagesController < ApplicationController

	include UsersHelper
	include MicropostsHelper
	
	def home
		@feeds = current_user.feed if logged_in?
		@video_title_counts_third = set_video_title_counts_third if any_microposts?
		
		@third_counts_of_likes_count = Micropost.set_third_counts_of_likes_count
		#ここのデフォルトスコープの影響をキータに投稿する
		@third_likes_counts_microposts = Micropost.set_third_likes_counts_microposts if any_liked_microposts?

		@third_counts_of_follower_count = User.set_third_counts_of_follower_count
		@third_follower_counts_users = User.set_third_follower_counts_users if any_follow?	
	end

	def about
	end

	def contact
	end

	def help
	end
	
end
