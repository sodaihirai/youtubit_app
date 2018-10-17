class LikesController < ApplicationController
	before_action :logged_in_user

	def create
		@micropost = Micropost.find(params[:micropost_id])
		@like = @micropost.like(current_user)
		if @like.save
			respond_to do |format|
				format.html { redirect_to request.referer }
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
			respond_to do |format|
				format.html { redirect_to request.referer }
				format.js
			end
		else
			redirect_to root_url
		end
	end

end
