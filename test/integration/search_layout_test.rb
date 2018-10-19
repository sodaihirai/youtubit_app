require 'test_helper'

class SearchLayoutTest < ActionDispatch::IntegrationTest
 
  def setup
  	@user = users(:Taro)
  	@micropost = microposts(:nice)
  	log_in_as @user
  end

end
