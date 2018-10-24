require 'test_helper'

class SearchOfUsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
  	@Taro = users(:Taro)
  	@Kazuo = users(:Kazuo)
  	@Hanako = users(:Hanako)
  	log_in_as @Taro
  end

  test "search of user index" do
  	get users_path
  	assert_template 'users/index'
  	assert_select 'a[href=?]', user_path(@Taro), count: 2
  	#assert_select 'a[href=?]', user_path(@Hanako)
  	post index_search_users_path, params: { q: " " }
  	assert_template 'users/index'
  	assert_select 'a[href=?]', user_path(@Taro), count: 2
  	#assert_select 'a[href=?]', user_path(@Hanako)
  	post index_search_users_path, params: { q: "jipajfeiaopjfsfpajsejopadio;jj" }
  	assert_template 'users/index'
  	assert_select 'a[href=?]', user_path(@Taro), count: 1
  	assert_select 'a[href=?]', user_path(@Hanako), count: 0
  	post index_search_users_path, params: { q: "Hanako" }
  	assert_template 'users/index'
  	assert_select 'a[href=?]', user_path(@Taro), count: 1
  	assert_select 'a[href=?]', user_path(@Hanako)
  	post index_search_users_path, params: { q: "Taro" }
  	assert_template 'users/index'
	assert_select 'a[href=?]', user_path(@Taro), count: 2
  	assert_select 'a[href=?]', user_path(@Hanako), count: 0
  end

end
