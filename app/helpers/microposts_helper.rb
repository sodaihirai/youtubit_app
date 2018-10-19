module MicropostsHelper

	def new_variable_set
		@video_title     = params[:video_title]
		@video_thumbnail = params[:video_thumbnail]
		@channel_title   = params[:channel_title]
		@video_url       = params[:video_url]
		@channel_url     = params[:channel_url]
	end

	def create_variable_set
		@video_title     = params[:micropost][:video_title]
		@video_thumbnail = params[:micropost][:video_thumbnail]
		@channel_title   = params[:micropost][:channel_title]
		@video_url       = params[:micropost][:video_url]
		@channel_url     = params[:micropost][:channel_url]
	end

	def like?(micropost)
		!micropost.likes.find_by(user_id: current_user.id).nil?
	end

end
