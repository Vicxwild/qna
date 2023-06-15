$(document).on('turbolinks:load', function(e) {
  $(".gist-content").each(function() {
    const gistUrl = $(this).data("gistUrl");

    this.src = gistUrl;
  });
});
