class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  # GET /user/:id
  def show
    @user = User.find(params[:id])
  end
  
  # GET /users/new
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user) #最初の変数が'@'userなの注意！
      flash[:success] = "Welcome to the Sample app!"
      redirect_to "/users/#{@user.id}"
      #redirect_to @user
      #GET "/users/#{@user.id}"
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Successfully update!"
      redirect_to @user
    else
      render 'edit'
      #User.rbで弾かれたエラーメッセージが帰ってくる
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to user_url
  end
  
  #ここより上に書く
  private
  #ストロングパラメータ
    def user_params
      params.require(:user).permit(:name, 
                                  :email, 
                                  :password,
                                  :password_confirmation
                                  )
    end
    
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      #編集したいユーザを呼び出す。
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
      #current_user #session.helper.rb
      #絶対に誰かがログインしてる(before_action :logged_in_user)の前提
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
