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
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  
  # GET /users/new
  def new
    @user = User.new
  end
  
  def create #user.rb berofe_create発動
    @user = User.new(user_params)
    #ストロングパラメータ
    if @user.save
      @user.send_activation_email
      #user.rbに記述
      
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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
    redirect_to users_path
  end
  
  #ここより上に書く
  private
  #####################
  
  #ストロングパラメータ
    def user_params
      params.require(:user).permit(:name, 
                                  :email, 
                                  :password,
                                  :password_confirmation
                                  )
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
