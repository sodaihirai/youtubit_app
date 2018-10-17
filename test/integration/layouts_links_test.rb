require 'test_helper'

class LayoutsLinksTest < ActionDispatch::IntegrationTest
 	test "layouts link" do
 		get root_path
 		assert_select 'a[href=?]', root_path
 		assert_select 'a[href=?]', about_path
 		assert_select 'a[href=?]', contact_path
 		assert_select 'a[href=?]', help_path
 	end
end
