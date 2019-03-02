class StaticPagesController < ApplicationController

	include UsersHelper
	include MicropostsHelper

	require '/Users/hiraisodai/Projects/youtubit_app/lib/content_data/content_loader.rb'
	
	def home
		ContentLoader.load!
		@feeds = current_user.feed if logged_in?
		@video_title_counts_third = set_video_title_counts_third if Micropost.any?
		
		@third_counts_of_likes_count = Micropost.set_third_counts_of_likes_count
		#ここのデフォルトスコープの影響をキータに投稿する
		@third_likes_counts_microposts = Micropost.set_third_likes_counts_microposts if Like.any?

		@third_counts_of_follower_count = User.set_third_counts_of_follower_count
		@third_follower_counts_users = User.set_third_follower_counts_users if Relationship.any?	
	end

	def about
	end

	def contact
	end

	def help
	end
	
end
