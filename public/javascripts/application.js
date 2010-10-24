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
	itemTemplate: '<li><img alt="{{title}}" src="{{image_s}}" /></li>'
  });
});

 
