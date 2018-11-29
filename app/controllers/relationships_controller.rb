class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		@user = User.find(params[:followed_id])
		current_user.follow(@user)
		content = "#{current_user.name}さんが#{@user.name}さんをフォローしました。"
		Action.create(action_user_id: current_user.id, type_id: @user.id, action_type: "follow")
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		relationship = Relationship.find(params[:id])
		@user = User.find(relationship.followed_id)
		current_user.active_relationships.find(params[:id]).destroy
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

end
