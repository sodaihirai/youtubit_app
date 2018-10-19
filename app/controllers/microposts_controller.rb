class MicropostsController < ApplicationController
	before_action :logged_in_user
	before_action :correct_user, only: :destroy

	include MicropostsHelper

	def input
	end

	def search
		#params[:keyword]がnilの時の条件分岐
		if !params[:keyword].blank?
			require 'google/apis/youtube_v3'
			youtube = Google::Apis::YoutubeV3::YouTubeService.new
			youtube.key = "AIzaSyD2Iqoeg3zYFPXTwCzc0nS-DXwt4DgfE74"
			youtube_search_list = youtube.list_searches("id,snippet", type: "video",
																    q: params[:keyword],
																    max_results: 5)
			@search_result = youtube_search_list.to_h
            @movies = @search_result[:items]
			if !@movies.nil?
				respond_to do |format|
					format.html { render 'input'}
					format.js
				end
			else
				flash[:warning] = "検索結果はありません"
				respond_to do |format|
					format.html { render 'input'}
					format.js
				end
			end
		else 
			flash.now[:warning] = "検索に空白は使えません"
			respond_to do |format|
				format.html { render 'input'}
				format.js
			end
		end
	end

	def new
		new_variable_set
		@micropost = current_user.microposts.build
	end

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash.now[:success] = "投稿に成功しました。"
			redirect_to current_user
		else
			create_variable_set
			render 'new'
		end
	end

	def destroy
		if @micropost = current_user.microposts.find(params[:id])
			@micropost.destroy
			flash[:success] = "削除に成功しました。"
			#投稿一覧から消した時は、投稿一覧に戻りたい
			redirect_to current_user
		end
	end

	def show
	end

	def index
		if params[:video_type].nil? || params[:video_type] == "全ジャンル"
			if params[:sort_version].nil? || params[:sort_version] == "post_created_at"
				@microposts = Micropost.page(params[:page])
				if params[:search_version].nil? || params[:search_version] == "content"
					@search_version_jp = "コメント"
				elsif params[:search_version] == "video_title"
					@search_version_jp = "ビデオタイトル"
				elsif params[:search_version] == "channel_title"
					@search_version_jp = "チャンネルタイトル"
				end
			elsif params[:sort_version] == "like_count"
				micropost_like_count = Micropost.joins(:likes).group(:micropost_id).count
	 			micropost_liked_ids = Hash[micropost_like_count.sort_by{ |_, v| -v }].keys
				@microposts = Micropost.where(id: micropost_liked_ids).page(params[:page])
				if params[:search_version].nil? || params[:search_version] == "content"
					@search_version_jp = "コメント"
				elsif params[:search_version] == "video_title"
					@search_version_jp = "ビデオタイトル"
				elsif params[:search_version] == "channel_title"
					@search_version_jp = "チャンネルタイトル"
				end
			end
		else
			if params[:sort_version].nil? || params[:sort_version] == "post_created_at"
				@microposts = Micropost.where('video_type = ?',params[:video_type]).page(params[:page])
				if params[:search_version].nil? || params[:search_version] == "content"
					@search_version_jp = "コメント"
				elsif params[:search_version] == "video_title"
					@search_version_jp = "ビデオタイトル"
				elsif params[:search_version] == "channel_title"
					@search_version_jp = "チャンネルタイトル"
				end
			elsif params[:sort_version] == "like_count"
				micropost_like_count = Micropost.joins(:likes).group(:micropost_id).count
	 			micropost_liked_ids = Hash[micropost_like_count.sort_by{ |_, v| -v }].keys
				@microposts = Micropost.where('id IN (?) AND video_type = ?', micropost_liked_ids, params[:video_type]).page(params[:page])
				if params[:search_version].nil? || params[:search_version] == "content"
					@search_version_jp = "コメント"
				elsif params[:search_version] == "video_title"
					@search_version_jp = "ビデオタイトル"
				elsif params[:search_version] == "channel_title"
					@search_version_jp = "チャンネルタイトル"
				end
			end
		end
	end

	def index_search
		#ジャンル指定がない
		if params[:video_type].empty? || params[:video_type] == "全ジャンル"
			#ジャンル指定がなく、フィルター指定もない
			if params[:sort_version].empty? || params[:sort_version] == "post_created_at"
				if params[:search_version].empty? || params[:search_version] == "content"
					params[:q]? @microposts = Micropost.search_by_content(params[:q]).page(params[:page]) : @microposts = Micropost.page(params[:page])			
					@search_version_jp = "コメント"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				elsif params[:search_version] == "video_title"
					params[:q]? @microposts = Micropost.search_by_video_title(params[:q]).page(params[:page]) : @microposts = Micropost.page(params[:page])
					@search_version_jp = "ビデオタイトル"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				elsif params[:search_version] == "channel_title"
					params[:q]? @microposts = Micropost.search_by_channel_title(params[:q]).page(params[:page]) : @microposts = Micropost.page(params[:page])
					@search_version_jp = "チャンネルタイトル"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				end
				#ジャンル指定がなく、フィルター指定はある。
			elsif params[:sort_version] == "like_count"
				 micropost_like_count = Micropost.joins(:likes).group(:micropost_id).count
	 			 micropost_liked_ids = Hash[micropost_like_count.sort_by{ |_, v| -v }].keys
				if params[:search_version].empty? || params[:search_version] == "content"
					params[:q]? @microposts = Micropost.search_by_content_sort_by_like(params[:q], micropost_liked_ids).page(params[:page]) : @microposts = Micropost.where(id: micropost_liked_ids).page(params[:page])			
					@search_version_jp = "コメント"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				elsif params[:search_version] == "video_title"
					params[:q]? @microposts = Micropost.search_by_video_title_sort_by_like(params[:q], micropost_liked_ids).page(params[:page]) : @microposts = Micropost.where(id: micropost_liked_ids).page(params[:page])
					@search_version_jp = "ビデオタイトル"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				elsif params[:search_version] == "channel_title"
					params[:q]? @microposts = Micropost.search_by_channel_title_sort_by_like(params[:q], micropost_liked_ids).page(params[:page]) : @microposts = Micropost.where(id: micropost_liked_ids).page(params[:page])
					@search_version_jp = "チャンネルタイトル"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				end
			end
		else #ジャンル指定がある
			#フィルター指定がない
			if params[:sort_version].empty? || params[:sort_version] == "post_created_at"
				if params[:search_version].empty? || params[:search_version] == "content"
					params[:q]? @microposts = Micropost.search_by_content_sort_by_video_type(params[:q], params[:video_type]).page(params[:page]) : @microposts = Micropost.page(params[:page])			
					@search_version_jp = "コメント"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				elsif params[:search_version] == "video_title"
					params[:q]? @microposts = Micropost.search_by_video_title_sort_by_video_type(params[:q], params[:video_type]).page(params[:page]) : @microposts = Micropost.page(params[:page])
					@search_version_jp = "ビデオタイトル"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				elsif params[:search_version] == "channel_title"
					params[:q]? @microposts = Micropost.search_by_channel_title_sort_by_video_type(params[:q], params[:video_type]).page(params[:page]) : @microposts = Micropost.page(params[:page])
					@search_version_jp = "チャンネルタイトル"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				end
				#ジャンル指定があり、フィルター指定もある。
			elsif params[:sort_version] == "like_count"
				 micropost_like_count = Micropost.joins(:likes).group(:micropost_id).count
	 			 micropost_liked_ids = Hash[micropost_like_count.sort_by{ |_, v| -v }].keys
				if params[:search_version].empty? || params[:search_version] == "content"
					params[:q]? @microposts = Micropost.search_by_content_sort_by_like_and_video_type(params[:q], micropost_liked_ids, params[:video_type]).page(params[:page]) : @microposts = Micropost.where(id: micropost_liked_ids).page(params[:page])			
					@search_version_jp = "コメント"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				elsif params[:search_version] == "video_title"
					params[:q]? @microposts = Micropost.search_by_video_title_sort_by_like_and_video_type(params[:q], micropost_liked_ids, params[:video_type]).page(params[:page]) : @microposts = Micropost.where(id: micropost_liked_ids).page(params[:page])
					@search_version_jp = "ビデオタイトル"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				elsif params[:search_version] == "channel_title"
					params[:q]? @microposts = Micropost.search_by_channel_title_sort_by_like_and_video_type(params[:q], micropost_liked_ids, params[:video_type]).page(params[:page]) : @microposts = Micropost.where(id: micropost_liked_ids).page(params[:page])
					@search_version_jp = "チャンネルタイトル"
					respond_to do |format|
						format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
						format.js
					end
				end
			end
		end
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content, :video_title, :video_url, :video_thumbnail, :video_type, :channel_title, :channel_url)
		end

		def correct_user
			micropost = Micropost.find(params[:id])
			user = User.find(micropost.user_id)
			unless current_user == user
				flash[:danger] = "正しいユーザーではありません"
				redirect_to root_url
			end
		end

end
