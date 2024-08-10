class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.last_day_created
    mail to: user.email, subject: "Daily digest"
  end
end
