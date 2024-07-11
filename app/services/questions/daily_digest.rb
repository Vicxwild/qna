module Questions
  class DailyDigestService
    def call
      questions = ActiveModelSerializers::SerializableResource.new(
        Question.last_day_created,
        each_serializer: QuestionDigestSerializer
      ).as_json

      User.find_each(batch_size: 500) do |user|
        DailyDigestMailer.send_digest(user, questions).deliver_later
      end
    end
  end
end
