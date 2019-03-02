module StaticPagesHelper

	def ranking_order(value, counts)
		if value == counts.first
			return 1
		elsif value == counts.second
			return 2
		#elsif value == counts.third
		else
			return 3
		end	
	end

	def video_url(video_title)
		Micropost.find_by(video_title: video_title).video_url
	end

	def video_thumbnail(video_title)
		Micropost.find_by(video_title: video_title).video_thumbnail
	end

	def front_banner(kind)
		content_data('/test/test', attr: kind)
	end
end
