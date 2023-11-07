const templateComment = require('../../templates/comment.hbs');

$(document).on('turbolinks:load', function() {
  $('.container')
    .on('ajax:success', '.add_comment', handlerSuccess)
    .on('ajax:error', '.add_comment', handlerError)
});

function handlerSuccess(e) {
  const response = e.originalEvent.detail[0];
  console.log(response)
  console.log(templateComment(response))
  $(this).find('.comment-body').val('');
  $(this).parents().children('.comments').append(templateComment(response));
}

function handlerError(e) {
  const response = e.originalEvent.detail[0];

  $('p.alert').empty();

  $.each(response, function(index, value) {
    $('p.alert').append(`<div class="flash-alert">${value}</div>`);
  });
};
