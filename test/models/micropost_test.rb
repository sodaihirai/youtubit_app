require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  
  def setup
  	@user = users(:Taro)
  	@micropost = @user.microposts.build(content: "amazing", video_title: "example", 
                                                              video_url: "exmaple.com",
		  								                                        video_thumbnail: "example.com",
		  								                                        video_type: "example",
                                                              channel_title: "example")
  end

  test "should be valid" do
  	assert @micropost.valid?
  end

  test "content should be presence" do
  	@micropost.content = nil
  	assert_not @micropost.valid?
  end

  test "video_title should be presence" do
  	@micropost.video_title = nil
  	assert_not @micropost.valid?
  end

  test "video_url should be presence" do
  	@micropost.video_url = nil
  	assert_not @micropost.valid?
  end

  test "video_thumbnail should be presence" do
  	@micropost.video_thumbnail = nil
  	assert_not @micropost.valid?
  end

  test "video_type should be presence" do
  	@micropost.video_type = nil
  	assert_not @micropost.valid?
  end

  test "microposts should depends on user" do
  	@user.save
  	assert @micropost.save
  	assert_difference "@user.microposts.count", -@user.microposts.count do
  		@user.destroy
  	end
  end

  test "content should be less than 140" do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end

end
