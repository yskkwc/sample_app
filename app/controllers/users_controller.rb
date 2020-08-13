class UsersController < ApplicationController
  # GET /users/:id
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
  
  private
  
  def user_params
    params.require(:user).permit(:name, 
                                 :email, 
                                 :password,
                                 :password_confirmation
                                 )
  end
end
