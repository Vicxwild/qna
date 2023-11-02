import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const questionsList = $('.questions')

  consumer.subscriptions.create("QuestionsChannel", {
    connected() {
      console.log('Connected to question_chanel');
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      questionsList.append(data);
    }
  });
});
