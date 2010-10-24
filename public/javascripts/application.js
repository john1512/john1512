$(document).ready(function(){
  var list = $("ul.jflickrfeed");
  var tag = list.attr("data-tag");
  if (tag === undefined) {
    tag = "";
  }
  $('ul.jflickrfeed').jflickrfeed({
	limit: 20,
	qstrings: {
          tags: "john1512," + tag
	},
	itemTemplate:
	'<li>' +
		'<a rel="colorbox" href="{{image}}" title="{{title}}">' +
			'<img src="{{image_s}}" alt="{{title}}" />' +
		'</a>' +
	'</li>'
  }, function(data) {
	$('.jflickrfeed a').colorbox();
  });
});
