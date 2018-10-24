require 'test_helper'

class SearchOfMicropostIndexTest < ActionDispatch::IntegrationTest

  def setup
  	@user = users(:Taro)
  	log_in_as @user
  end

  test "search of micropost index with just q parameter" do
  	post index_search_microposts_path, params: { q: "nice", video_type:"", sort_version: "", search_version: "" }
  	assert_template 'microposts/index'
  	assert_select 'a[href=?]', micropost_path(microposts(:nice))
  	assert_select 'a[href=?]', micropost_path(microposts(:nice2))
  	assert_select 'a[href=?]', micropost_path(microposts(:nice3))
  	assert_select 'a[href=?]', micropost_path(microposts(:nice4))
  	assert_select 'a[href=?]', micropost_path(microposts(:good)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:good2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:good3)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:hungry)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:hungry2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:sleepy)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:sleepy2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:angry)), count: 0
  end

  test "search of micropost index with search_version" do
  	post index_search_microposts_path, params: { q: "nice", video_type:"", sort_version: "", search_version: "content" }
  	assert_template 'microposts/index'
   	assert_select 'a[href=?]', micropost_path(microposts(:nice))
  	assert_select 'a[href=?]', micropost_path(microposts(:nice2))
  	assert_select 'a[href=?]', micropost_path(microposts(:nice3))
  	assert_select 'a[href=?]', micropost_path(microposts(:nice4))
  	assert_select 'a[href=?]', micropost_path(microposts(:good)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:good2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:good3)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:hungry)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:hungry2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:sleepy)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:sleepy2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:angry)), count: 0
  	post index_search_microposts_path, params: { q: "awesome foods", video_type:"", sort_version: "", search_version: "video_title" }
  	assert_template 'microposts/index'
    assert_select 'a[href=?]', micropost_path(microposts(:nice)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:nice2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:nice3))
  	assert_select 'a[href=?]', micropost_path(microposts(:nice4))
  	assert_select 'a[href=?]', micropost_path(microposts(:good)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:good2)) 
  	assert_select 'a[href=?]', micropost_path(microposts(:good3)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:hungry)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:hungry2)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:sleepy)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:sleepy2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:angry)), count: 0 
   	post index_search_microposts_path, params: { q: "dry", video_type:"", sort_version: "", search_version: "channel_title" }
  	assert_template 'microposts/index'
    assert_select 'a[href=?]', micropost_path(microposts(:nice))
  	assert_select 'a[href=?]', micropost_path(microposts(:nice2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:nice3)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:nice4)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:good))
  	assert_select 'a[href=?]', micropost_path(microposts(:good2)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:good3)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:hungry))
  	assert_select 'a[href=?]', micropost_path(microposts(:hungry2)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:sleepy))
  	assert_select 'a[href=?]', micropost_path(microposts(:sleepy2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:angry))
  end

  test "search of micropost index with video_type" do
  	post index_search_microposts_path, params: { q: "awesome foods", video_type:"motivation", sort_version: "", search_version: "video_title" }
  	assert_template 'microposts/index'
    assert_select 'a[href=?]', micropost_path(microposts(:nice)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:nice2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:nice3))
  	assert_select 'a[href=?]', micropost_path(microposts(:nice4)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:good)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:good2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:good3)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:hungry)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:hungry2)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:sleepy)), count: 0 
  	assert_select 'a[href=?]', micropost_path(microposts(:sleepy2)), count: 0
  	assert_select 'a[href=?]', micropost_path(microposts(:angry)), count: 0 
  	
  end

end
