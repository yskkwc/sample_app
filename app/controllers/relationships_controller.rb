class RelationshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    #user.rbで定義
    respond_to do |format|
      format.html { redirect_to @user }
      format.js #/relationships/create.js.erb
    end
  end
  
  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    #user.rbで定義
    respond_to do |format|
      format.html { redirect_to @user }
      format.js #relationships/destroy.js.erb
    end
  end
end
