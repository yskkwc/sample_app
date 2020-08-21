class UserMailer < ApplicationMailer

  def account_activation
    @greeting = "Hi"

    mail to: "to@example.org"
  end
  
  def account_activation(user)
    @user = user
    mail      to: user.email, 
         subject: "Account activation"
    #return: mail object(text/html)
    #ユーザー宛にメール送るよ　（user．email）
    #件名はAccount activationにするよ
  end
  
  def password_reset
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
