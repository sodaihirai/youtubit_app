require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:Taro)
  	@micropost = microposts(:nice)
    @other = users(:Hanako)
    @other_micropost = microposts(:good)
  end

  test "input should redirect when not logged in" do
  	get input_microposts_path
  	assert_redirected_to login_url
  end

  test "search should redirect when not logged in" do
  	post search_microposts_path, params: { keyword: "youtube" }
  	assert_redirected_to login_url
  end

  test "new should redirect when not logged in" do
  	get new_micropost_path, params: { video_title: "youtube",
  									 	video_thumbnail: "youtube.jpg",
  									 	channel_title: "youtube",
  										video_url: "youtube.com" }
  	assert_redirected_to login_url
  end

  test "create should redirect when not logged in" do
  	post microposts_path, params: { micropost: { content: "youtube",
	  												video_title: "youtube",
			  									 	video_thumbnail: "youtube.jpg",
			  									 	channel_title: "youtube",
			  										video_url: "youtube.com" } }
	assert_redirected_to login_url
  end

  test "destroy should redirect when not logged in" do
    assert_no_difference '@user.microposts.count' do
  	   delete micropost_path(@micropost)
    end
  	assert_redirected_to login_url
  end

  test "destroy should redirect when wrong user" do
    log_in_as @user
    assert_no_difference '@other.microposts.count' do
      delete micropost_path(@other_micropost)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end


  test "show should redirect when not logged in" do
  	get micropost_path @micropost
    assert_redirected_to login_url
  end

  test "index should redirect when not logged in" do
  	get microposts_path
    assert_redirected_to login_url
  end
end
