class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :unsubscribe, :destroy, :followers, :following]
  before_action :correct_user, only: [:edit, :update, :unsubscribe, :destroy]

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:warning] = "アカウント有効化のためのメールを確認してください。"
      redirect_to root_url
  	else
  		render 'new'
  	end
  end

  def index
    @users = User.page(params[:page])
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.all
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

  def followers
    @user = User.find(params[:id])
    @followers = @user.followers
  end

  def following
    @user = User.find(params[:id])
    @following = @user.following
  end

  private
  	def user_params
  		params.require(:user).permit(:email, :name,
                                           :password, 
                                           :password_confirmation)
  	end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:danger] = "正しいユーザーではありません"
        redirect_to root_url
      end
    end
end
