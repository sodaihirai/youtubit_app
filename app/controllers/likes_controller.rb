class LikesController < ApplicationController
	before_action :logged_in_user

	def create
		@micropost = Micropost.find(params[:micropost_id])
		@like = @micropost.like(current_user)
		if @like.save
			@third_counts_of_likes_count = Micropost.set_third_counts_of_likes_count
			@third_likes_counts_microposts = Micropost.set_third_likes_counts_microposts if any_liked_microposts?
			respond_to do |format|
				format.html { redirect_to request.referer || root_path }
				format.js
			end
		else
			redirect_to root_url
		end
	end

	def destroy
		@like = Like.find(params[:id])
		@micropost = Micropost.find(@like.micropost.id)
		if @like
			@like.destroy
			@third_counts_of_likes_count = Micropost.set_third_counts_of_likes_count
			@third_likes_counts_microposts = Micropost.set_third_likes_counts_microposts if any_liked_microposts?
			respond_to do |format|
				format.html { redirect_to request.referer || root_path }
				format.js
			end
		else
			redirect_to microposts_path
		end
	end

end
