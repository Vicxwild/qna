// Клиент подписывается на канал появлений с помощью consumer.subscriptions.create({ channel: "AppearanceChannel" }). (appearance_channel.js)
import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const answersList = $('.answers')

  consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log("Connected to answers_chanel_" + gon.question_id);
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      // нужен шаблон для передачи в него данных и рендеринге на клиенте
      console.log(data);
      answersList.append(data.answer.body);
    }
  });
});
