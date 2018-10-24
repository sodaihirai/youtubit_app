require 'test_helper'

class MessageTest < ActiveSupport::TestCase
 
 def setup
 	@user = users(:Taro)
 	@other = users(:Hanako)
 	@message = @user.from_messages.build(content: "よろしく", to_id: @other.id, room_id: "#{@user.id}-#{@other.id}")
 end

 test "should be valid" do
 	assert @message.valid?
 end

 test "from_id should be presence" do
 	@message.from_id = nil
 	assert_not @message.valid?
 end

 test "to_id should be presence" do
 	@message.to_id = nil
 	assert_not @message.valid?
 end

 test "room_id should be presence" do
 	@message.room_id = nil
 	assert_not @message.valid?
 end

 test "content should be presence" do
 	@message.content = nil
 	assert_not @message.valid?
 end

 test "message destroy when sender is destroyed" do
 	assert_difference '@user.from_messages.count', -@user.from_messages.count do
 		@user.destroy
 	end
 end

 test "message destroy when receiver is destroyed" do
 	assert_difference '@other.to_messages.count', -@other.to_messages.count do
 		@other.destroy
 	end
 end

end
