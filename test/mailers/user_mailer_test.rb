require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    #fixture
    user.activation_token = User.new_token
    #ランダムトークン生成
    mail = UserMailer.account_activation(user)
    #user_mailer_preview
    #UserMailerオブジェクトにmichaelさん情報押し込む
    
    assert_equal "Account activation", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.name,               mail.body.encoded
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end

end
