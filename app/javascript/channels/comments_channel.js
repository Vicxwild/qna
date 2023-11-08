import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
  const templateComment = require('../templates/comment.hbs');

  consumer.subscriptions.create("CommentsChannel", {
    connected() {
      console.log("Connected to comments_channel");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      if (gon.sid === data.sid) return;

      const comment_type = data.commentable_type;

      const commentFullTemplate = templateComment(data);

      switch (comment_type) {
        case 'Question':
          $('.question .comments').append(commentFullTemplate);
          break;
        case 'Answer':
          $('#answer_' + data.commentable_id + ' .comments').append(commentFullTemplate);
          break;
        default:
      }
    }
  });
});
