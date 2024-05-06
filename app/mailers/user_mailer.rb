# app/mailers/user_mailer.rb

class UserMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to freshbooks') do |format|
      format.text { render plain: "Welcome, #{user.name}!" }
      format.html { render layout: 'mailer', template: 'user_mailer/welcome_email' }
    end
  end
end
