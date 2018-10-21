class StaticPagesController < ApplicationController

	include UsersHelper
	include MicropostsHelper
	#下のfirstとlastの違いの謎の解明
	def home
		@feeds = current_user.feed if logged_in?
		@video_title_counts_third = set_video_title_counts_third if any_microposts?
		
		#@third_counts_of_likes_count = Micropost.where.not(likes_count: 0).group(:likes_count).count.values.uniq.max(3)
		@third_counts_of_likes_count = Micropost.where.not(likes_count: 0).order(likes_count: :asc).map{ |micropost| micropost.likes_count }.uniq.max(3)
		@third_likes_counts_microposts = Micropost.set_third_likes_counts_microposts if any_liked_microposts?

		@third_counts_of_follower_count = User.where.not(follower_count: 0).order(follower_count: :desc).map{ |user| user.follower_count}.uniq.max(3)
		@third_follower_counts_users = User.set_third_follower_counts_users if any_follow?	
	end

	def about
	end

	def contact
	end

	def help
	end
	
end
