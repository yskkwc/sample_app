class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      #user.rbに記述
      
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
      
  end

  def edit
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
      #ok= check expiration
      #ok= バリデーション チェック
      #ok= passwordがblankだった時はエラー追加してrender
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
  #####################
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
    # update action
  end
  
  def get_user
    @user = User.find_by(email: params[:email])
  end
  
  def valid_user
    unless (@user && @user.activated? &&
      @user.authenticated?(:reset, params[:id]))
    #nil check, activated=true?, (:reset, token)=authenticated = true?
    
    redirect_to root_url
    end
  end
  
  def check_expiration
    if @user.password_reset_expired?
      #期限切れですか？ user.rb
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
end
