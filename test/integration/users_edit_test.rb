require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "unsuccessful edit" do
    #編集失敗した時のテスト
    log_in_as(@user)
    get edit_user_path(@user)
    # @user = :michaelさん(テスト用ユーザ)
    assert_template 'users/edit'
    patch user_path(@user), params: 
    { user: { 
      name:                  "",
      email:                 "foo@invalid",
      password:              "foo",
      password_confirmation: "bar" 
    } }
    
    assert_template 'users/edit'
    assert_select   "div.alert", "The form contains 4 errors."
  end
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    # @user = :michaelさん(テスト用ユーザ)
    name  = "Foobar"
    email = "foo@bar.com"
    patch user_path(@user), 
    params: { user:{
      name:                  name,
      email:                 email,
      password:              "",
      password_confirmation: ""
    }}
    #michaelさんを呼び出してname,emailを変更
    #passwordは変更しない(空欄で以前のままを使用)
    assert_not flash.empty?
    #successfully〜と出るはず
    assert_redirected_to @user
    #users/show/:idにいくはず
    @user.reload
    #dbから更新したデータをリロード
    assert_equal name,  @user.name
    #"Foobar"
    assert_equal email, @user.email
    #"foo@bar.com"
  end
end
