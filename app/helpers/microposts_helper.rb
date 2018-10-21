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

	def micropost_search_version_jp
		if params[:search_version].nil? || params[:search_version] == "content"
			@search_version_jp = "コメント"
		elsif params[:search_version] == "video_title"
			@search_version_jp = "ビデオタイトル"
		elsif params[:search_version] == "channel_title"
			@search_version_jp = "チャンネルタイトル"
		end
	end 

	def set_micropost_liked_ids
		micropost_like_count = Micropost.joins(:likes).group(:micropost_id).count
		@micropost_liked_ids = Hash[micropost_like_count.sort_by{ |_, v| -v }].keys
	end

	def any_liked_microposts?
		!Micropost.where.not(likes_count: 0).group(:likes_count).max(3).first.nil?
	end

	def any_microposts?
		!Micropost.group(:video_title).count.values.uniq.max(3).last.nil?
	end

	def set_video_title_counts_third
		@third_posted_counts = Micropost.group(:video_title).count.values.uniq.max(3)
		micropost_video_title_count = Micropost.group(:video_title).count
		video_title_counts = Hash[micropost_video_title_count.sort_by{ |_, v| -v }]
		return Hash[video_title_counts.take_while{ |k, v| v >= @third_posted_counts.last }]
	end

end
