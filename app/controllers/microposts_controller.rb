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
																    max_results: 2)
			@search_result = youtube_search_list.to_h
            @movies = @search_result[:items]
			if !@movies.nil?
				render 'input'
			else
				flash[:warning] = "検索結果はありません"
				render 'input'
			end
		else 
			flash.now[:warning] = "検索に空白は使えません"
			render 'input'
		end
	end

	def new
		new_variable_set
		@micropost = current_user.microposts.build
	end

	def create
		@micropost = current_user.microposts.build(micropost_params)
		if @micropost.save
			flash[:success] = "投稿に成功しました。"
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
	end

	def index
		@microposts = Micropost.all
	end

	private

		def micropost_params
			params.require(:micropost).permit(:content, :video_title, :video_url, :video_thumbnail, :video_type, :channel_title)
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
