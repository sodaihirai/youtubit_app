class MicropostsController < ApplicationController
	before_action :logged_in_user
	before_action :correct_user, only: :destroy

	include MicropostsHelper

	def input
	end

	def search
		if !params[:keyword].blank?
			require 'google/apis/youtube_v3'
			youtube = Google::Apis::YoutubeV3::YouTubeService.new
			youtube.key = "AIzaSyD2Iqoeg3zYFPXTwCzc0nS-DXwt4DgfE74"
			youtube_search_list = youtube.list_searches("id,snippet", type: "video",
																    q: params[:keyword],
																    max_results: 5)
			search_result = youtube_search_list.to_h
            @movies = search_result[:items]
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
			redirect_to current_user
		end
	end

	def show
		@micropost = Micropost.find(params[:id])
	end

	def index
		if params[:video_type].nil? || params[:video_type] == "全ジャンル"
			if params[:sort_version].nil? || params[:sort_version] == "post_created_at"
				@microposts = Micropost.page(params[:page])
				micropost_search_version_jp
			elsif params[:sort_version] == "like_count"
				@microposts = Micropost.order(likes_count: :desc).page(params[:page])
				micropost_search_version_jp
			end
		else
			if params[:sort_version].nil? || params[:sort_version] == "post_created_at"
				@microposts = Micropost.where('video_type = ?',params[:video_type]).page(params[:page])
				micropost_search_version_jp
			elsif params[:sort_version] == "like_count"
				@microposts = Micropost.where('video_type = ?', params[:video_type]).order(likes_count: :desc).page(params[:page])
				micropost_search_version_jp
			end
		end
	end

	def index_search
		if params[:video_type].empty? || params[:video_type] == "全ジャンル"
			if params[:sort_version].empty? || params[:sort_version] == "post_created_at"
				params[:search_version].empty? ? search_version = "content" : search_version = params[:search_version]
			    @microposts = Micropost.search_by_parameter_with_pagination(search_version, params[:q], params[:page])
			    respond_to do |format|
					format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
					format.js
			    end
				micropost_search_version_jp
			elsif params[:sort_version] == "like_count"
			    params[:search_version].empty? ? search_version = "content" : search_version = params[:search_version]
			    @microposts = Micropost.search_by_parameter_sort_by_like_with_pagination(search_version, params[:q], params[:page])
			    respond_to do |format|
					format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
					format.js
			    end
				micropost_search_version_jp			   
			end
		else 
			if params[:sort_version].empty? || params[:sort_version] == "post_created_at"
				params[:search_version].empty? ? search_version = "content" : search_version = params[:search_version]
				@microposts = Micropost.search_by_parameter_sort_by_video_type_with_pagination(search_version, params[:q], params[:video_type], params[:page])
			    respond_to do |format|
					format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
					format.js
			    end
				micropost_search_version_jp			   
			elsif params[:sort_version] == "like_count"
				params[:search_version].empty? ? search_version = "content" : search_version = params[:search_version]
				@microposts = Micropost.search_by_parameter_sort_by_like_and_video_type_with_pagination(search_version, params[:q], params[:video_type], params[:page])
			    respond_to do |format|
					format.html { render 'index', search_version: params[:search_version], sort_version: params[:sort_version], video_type: params[:video_type] }
					format.js
			    end
				micropost_search_version_jp			   
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
