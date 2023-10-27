$(document).on('turbolinks:load', function() {
  $('.like, .dislike').on('ajax:success', function(e) {
    const response = e.detail[0];
    const votesSumElement = $(this).closest('.votes').find('.votes-sum');
    votesSumElement.text(response.vote_sum);

    if (response.vote_sum > 0) {
      votesSumElement.removeClass('text-danger').addClass('text-success');
    } else if (response.vote_sum < 0) {
      votesSumElement.removeClass('text-success').addClass('text-danger');
    } else {
      votesSumElement.removeClass('text-success text-danger');
    }
  }).on('ajax:error', function(e) {
    const errors = e.detail[0];

    $.each(errors, function(index, value) {
      $('p.notice').append(`<div class="flash-alert">${value}</div>`);
    });
  });
});

