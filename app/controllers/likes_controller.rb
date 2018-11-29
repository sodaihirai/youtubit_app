class LikesController < ApplicationController
	before_action :logged_in_user

	def create
		@micropost = Micropost.find(params[:micropost_id])
		@like = @micropost.like(current_user)
		if @like.save
			content = "#{current_user.name}さんが#{@micropost.contributor.name}さんの「#{@micropost.video_title}」という動画に対する投稿にいいねをしました"
			Action.create(action_user_id: current_user.id, type_id: @micropost.id, action_type: "like")
			@third_counts_of_likes_count = Micropost.set_third_counts_of_likes_count
			@third_likes_counts_microposts = Micropost.set_third_likes_counts_microposts if Like.any?
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
			@third_likes_counts_microposts = Micropost.set_third_likes_counts_microposts if Like.any?
			respond_to do |format|
				format.html { redirect_to request.referer || root_path }
				format.js
			end
		else
			redirect_to microposts_path
		end
	end

end
