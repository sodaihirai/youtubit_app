class AccountActivationsController < ApplicationController

	def edit
		@user = User.find_by(email: params[:email])
		if @user && !@user.activated? && @user.authenticated?(:activation, params[:id])
			@user.update_attribute(:activated,    true)
			@user.update_attribute(:activated_at, Time.zone.now)
			log_in @user
			flash[:success] = "有効化に成功しました。"
			redirect_to @user
		else 
			flash[:danger] = "不正な有効化リンクです。"
			redirect_to root_url
		end
	end
end
