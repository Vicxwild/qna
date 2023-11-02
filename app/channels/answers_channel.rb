class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answers_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
