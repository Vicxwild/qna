class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = ActiveModelSerializers::SerializableResource.new(
      Question.last_day_created,
      each_serializer: QuestionDigestSerializer
    ).as_json

    mail to: user.email, subject: "Daily digest"
  end
end
