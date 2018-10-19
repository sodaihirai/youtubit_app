require 'test_helper'

class MicropostFlowTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:Taro)
  	log_in_as(@user)
  end

  test "micropost create flow" do
  	get input_microposts_path
  	assert_template 'microposts/input'	
  	#検索ワードが空の時
  	post search_microposts_path, params: { keyword: "  " }
  	assert_not flash.empty?
  	assert_template 'microposts/input'
  	#検索ワードが空でない時
  	post search_microposts_path, params: { keyword: "youtube" }
  	assert_template 'microposts/input'
  	video_title = "video_title"
  	video_thumbnail = "icon.png"
  	channel_title = "channel_title"
  	video_url = "video_url"
    channel_url = "channel_url"
  	get new_micropost_path(video_title: video_title, video_thumbnail: video_thumbnail, channel_title: channel_title, video_url: video_url, channel_url: channel_url)
  	assert_template 'microposts/new'
  	content = "exmaple"
  	video_type = "sports"
  	#contentが空
  	assert_no_difference '@user.microposts.count' do
  		post microposts_path, params: { micropost: { content: " ", video_type: video_type, video_title: video_title, video_thumbnail: video_thumbnail, channel_title: channel_title, video_url: video_url, user_id: @user.id, channel_url: channel_url } }
  	end
  	assert_select 'div.error_explanation'
  	assert_template 'microposts/new'
  	#video_typeが空
  	assert_no_difference '@user.microposts.count' do
  		post microposts_path, params: { micropost: { content: content, video_type: " ", video_title: video_title, video_thumbnail: video_thumbnail, channel_title: channel_title, video_url: video_url, user_id: @user.id, channel_url: channel_url } }
  	end
  	assert_select 'div.error_explanation'
  	assert_template 'microposts/new'
  	#どちらも正しい
  	assert_difference '@user.microposts.count', 1 do
  		post microposts_path, params: { micropost: { content: content, video_type: video_type, video_title: video_title, video_thumbnail: video_thumbnail, channel_title: channel_title, video_url: video_url, user_id: @user.id, channel_url: channel_url } }
  	end
  	@micropost = assigns(:micropost)
  	@micropost.reload
  	#投稿情報がしっかり保存されているか
  	assert_equal content, @micropost.content
  	assert_equal video_type, @micropost.video_type
  	assert_equal video_title, @micropost.video_title
  	assert_equal video_thumbnail, @micropost.video_thumbnail
  	assert_equal channel_title, @micropost.channel_title
  	assert_equal video_url, @micropost.video_url
  	assert_not flash.empty?
  	assert_redirected_to @user
  	follow_redirect!
  	#投稿情報がviewに反映されている確認
  	assert_match @micropost.content, response.body
  	assert_match @micropost.video_type, response.body
  	assert_match @micropost.video_title, response.body
  	#assert_match @micropost.channel_title, response.body
  	assert_select "a[href=?]", @micropost.video_url
	#imgのassertの仕方
 end

end
