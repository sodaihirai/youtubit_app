class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :unsubscribe, :destroy]
  before_action :correct_user, only: [:edit, :update, :unsubscribe, :destroy]

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user
  		flash[:success] = "登録完了"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def index
    @users = User.all
  end

  def show
  	@user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "編集完了"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def unsubscribe
  end

  def destroy
    @user.destroy
    session.delete(:user_id)
    flash[:success] = "アカウントを削除しました"
    redirect_to root_url
  end

  private
  	def user_params
  		params.require(:user).permit(:email, :name, :password, :password_confirmation)
  	end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインをしてください"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "正しいユーザーではありません"
        redirect_to root_url
      end
    end
end
