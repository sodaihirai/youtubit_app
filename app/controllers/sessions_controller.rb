class SessionsController < ApplicationController

  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email])
  	if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
  		  log_in @user
        params[:session][:remember_me] == "1"? remember(@user) : forget(@user)
        redirect_back_or root_url
      else
        flash[:warning] = "アカウントが有効化されていません。メールの確認をしてください。"
        redirect_to root_url
      end
  	else
  		flash[:danger] = "メールアドレスまたは、パスワードが間違っています。"
  		render 'new'
  	end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
