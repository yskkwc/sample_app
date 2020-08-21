class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password]) 
      #ユーザーがデータベースにあり(userがtrue)、かつ、
      #認証に成功した場合(user.authenticateがtrue)にのみtrue=Success
      if user.activated?
        log_in user
        #↑メソッド + 引数, セッションを取得するメソッド
        #(session[:user_id]=user.id), module SessionsHelper def log_in
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message = "Account not activated"
        message = "Check your email for the activation links"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      #false = Fail
      #alert-class danger
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
  
end
