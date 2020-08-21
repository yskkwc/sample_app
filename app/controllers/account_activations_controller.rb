class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      #nil check, ２回目以降のアクセスを弾く, [:id]にはトークンが入ってる
      #/account_activations/zr5V1mPDGmMUPUMGsc1dgQ
      #/edit?email=y.k.trial.serv%40gmail.com
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activate"
      redirect_to root_url
    end
  end
end
