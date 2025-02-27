module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) #ここで復元
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        #userがnilじゃないかつ、authenticated?メソッドで
        #cookiesに保存していたremember_tokenが認証出来たら
        log_in user
        #sessionを作るよ！
        @current_user = user
        #このuserを@current_userにするよ!
      end
    end
  end
  
  def current_user?(user)
    #nilガード
    user && user == current_user
  end
    
  
  def logged_in?
    !current_user.nil?
    #current_userがnilではない = login状態
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  #セッションの永続化
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 記憶したURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
