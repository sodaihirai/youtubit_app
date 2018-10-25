class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :unsubscribe, :destroy, :followers, :following, :index_search, :chat, :chat_index, :chat_search]
  before_action :correct_user, only: [:edit, :update, :unsubscribe, :destroy, :chat_index, :chat_index_search, :chat_search]
  before_action :yourself, only: [:chat]

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

  def index_search
    params[:q]? @users = User.search_by_user_name(params[:q]).page(params[:page]) : @users = User.page(params[:page])
    respond_to do |format|
      format.html { render 'index' }
      format.js
    end
  end

  def show
  	@user = User.find(params[:id])
    @microposts = @user.microposts.all
    if current_user?(@user) 
      @latest_three_room_ids = Message.set_latest_room_ids(current_user).first(3)
      @latest_message_each_room = []
      @latest_three_room_ids.count.times do |n|
        @latest_message_each_room << Message.where(room_id: @latest_three_room_ids[n].room_id).last
      end
    end
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

  def chat
      @user = User.find(params[:id])
      @room_id = message_room_id(current_user, @user)
      @messages = Message.recent_in_room(@room_id)
  end

  def chat_index
      @set = Message.select(:room_id).distinct.order(created_at: :desc)
      @latest_room_ids = Message.set_latest_room_ids(current_user)
      @latest_message_each_room = []
      @latest_room_ids.count.count.times do |n|
        @latest_message_each_room << Message.where(room_id: @latest_room_ids[n].room_id).last
      end
  end
  #ajaxも
  def chat_search
    chat_users_ids = User.search_by_user_name(params[:q]).map { |user| user.id }
    #上をインスタンス変数からローカル変数に直したら、[]が消えた。
    @latest_room_ids = Message.set_latest_room_ids_for_search(chat_users_ids, current_user)
    @latest_message_each_room = []
    @latest_room_ids.count.count.times do |n|
      @latest_message_each_room << Message.where(room_id: @latest_room_ids[n].room_id).last 
    end
    respond_to do |format|
      format.html { render 'chat_index' }
      format.js
    end
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

    def yourself
      @user = User.find(params[:id])
      if current_user?(@user)
        flash[:danger] = "正しいユーザーではありません"
        redirect_to root_url
      end
    end

    def message_room_id(first_user, second_user)
      if first_user.id < second_user.id
        "#{first_user.id}-#{second_user.id}"
      else
        "#{second_user.id}-#{first_user.id}"
      end
    end

end
