$(document).on('turbolinks:load', function(e) {
  $(".gist-content").each(function() {
    const gistUrl = $(this).data("gistUrl");

    this.src = `data:text/html;charset=utf-8,<head><base target='_blank' /></head><body><script src=${gistUrl}></script></body>`
  });
});

$(document).on('change', '.gist-content', function() {
  const gistUrl = $(this).data("gistUrl");

  this.src = `data:text/html;charset=utf-8,<head><base target='_blank' /></head><body><script src=${gistUrl}></script></body>`
});
