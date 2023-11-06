# Сервер распознает, что была инициализирована новая подписка для канала появлений, и запускает колбэк subscribed, вызывающий метод appear на current_user. (appearance_channel.rb)

class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "answers_channel_#{params[:question_id]}"
  end
end
