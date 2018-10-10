class PasswordResetsController < ApplicationController
	before_action :get_user, only: [:edit, :update]
	before_action :check_mail_expiration, only: [:edit, :update]
	before_action :valid_user?, only: [:edit, :update]

	def new
	end

	def create
		if @user = User.find_by(email: params[:password_reset][:email])
			@user.create_reset_digest
			UserMailer.password_reset(@user).deliver_now
			flash[:warning] = "パスワード変更のメールを確認してください"
			redirect_to root_url
		else
			flash[:danger] = "無効なメールアドレスです"
			render 'new'
		end
	end

	def edit
	end

	def update
		if params[:user][:password].empty?
			flash.now[:warning] = "空のパスワードは登録できません"
			render 'edit'
		elsif @user.update_attributes(user_params)
			flash[:success] = "パスワードの変更が完了しました。"
			#friendlyforwardingした方が良いかも
			log_in @user
			redirect_to @user
		else
			flash.now[:danger] = "無効なパスワードです"
			render 'edit'
		end
	end

	private
		def get_user
			@user = User.find_by(email: params[:email])
			if @user.nil?
				redirect_to root_url
			end
		end

		def user_params
			params.require(:user).permit(:password, :password_confirmation)
		end

		def check_mail_expiration
			@user.password_reset_expired?
		end

		def valid_user?
			unless @user && @user.authenticated?(:reset, params[:id]) && @user.activated?
				flash[:danger] = "無効なリンクです"
				redirect_to root_url
			end
		end

end
