$(document).ready(function(){
  $('ul.jflickrfeed').jflickrfeed({
	limit: 2,
	qstrings: {
		id: '44802888@N04'
	},
	itemTemplate: '<li><img alt="{{title}}" src="{{image_s}}" /></li>'
  });
});

 
