require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty? #flashはemptyジャないよね？
    #↑新しいセッションのフォームが再度表示され、
    #フラッシュメッセージが追加されることを確認する
    get root_path
    assert flash.empty? #flashはemptyだよね？
  end
end
