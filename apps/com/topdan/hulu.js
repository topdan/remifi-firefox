//
// @import lib/all
// @url    http://www.hulu.com
//

route("/", "index", function() {
  action("doSearch");
});

route("/search", "search", function() {
  action("doSearch");
  action("prevPage");
  action("nextPage");
})

route(/^\/browse/, 'browse', function() {
  action("prevPage");
  action("nextPage");
});

route(/^\/popular/, 'browse', function() {
  action("prevPage");
  action("nextPage");
});

route(/^\/recent/, 'browse', function() {
  action("prevPage");
  action("nextPage");
});

route(/^\/[^\/]+$/, 'tvShowOrMovie', function() {
  action('loadMoreEpisodes');
})

function tvShowOrMovie(request) {
  if ($('#episode-container').length > 0) {
    tvShow(request);
  } else {
    movie(request);
  }
}

function tvShow(request) {
  title($('meta[property="og:title"]').attr('content'));
  
  $('#episode-container .vsl li').list(function(r) {
    var e = $(this);
    var title = e.find('.video-info');
    var thumb = e.find('.thumbnail');
    
    r.title = title.text();
    r.url   = title.attr('href');
    r.image = thumb.attr('data-src') || thumb.attr('src');
  });
  
  paginate([{name: 'next', url: 'loadMoreEpisodes'}])
}

function loadMoreEpisodes(request) {
  var elem = $('#episode-container .pages li.next');
  clickOn(elem);
  wait();
}

function movie(request) {
  
}

function clickOn(elem, options) {
  if (options == null) options = {}
  if (options.control == null) options.control = false;
  if (options.alt == null) options.alt = false;
  if (options.shift == null) options.shift = false;
  if (options.meta == null) options.meta = false;
  if (options.button == null) options.button = 0;
  
  var elem = elem.get(0);
  
  var evt = document.createEvent("MouseEvents")
  evt.initMouseEvent('click', true, true, null, 0, 0, 0, 0, 0, options.control, options.alt, options.shift, options.meta, options.button, null)
  
  elem.dispatchEvent(evt)
}

function prevPage(request) {
  var elem = $($('.page li').get(2)).find('a');
  clickOn(elem);
  wait();
}

function nextPage(request) {
  var elem = $($('.page li').get(6)).find('a');
  clickOn(elem);
  wait();
}

function index(request) {
  searchForm();
  
  list([
    { title: "Most Popular TV Shows",
      url: "http://www.hulu.com/browse/popular/tv?src=topnav"
    },
    { title: "Most Popular TV Episodes",
      url: "http://www.hulu.com/popular/episodes?src=topnav"
    },
    { title: "Recently Added TV Episodes",
      url: "http://www.hulu.com/recent/episodes?src=topnav"
    },
    { title: "Most Popular Movies",
      url: "http://www.hulu.com/popular/feature_films?src=topnav"
    },
    { title: "Most Popular Trailers",
      url: "http://www.hulu.com/popular/film_trailers?src=topnav"
    },
    { title: "Recently Added Movies",
      url: "http://www.hulu.com/recent/feature_films?src=topnav"
    },
    { title: "Recently Added Trailers",
      url: "http://www.hulu.com/recent/film_trailers?src=topnav"
    },
  ])
}

function browse(request) {
  results('#videos-list td');
}

function search(request) {
  searchForm();
  
  $('#show-page').list(function(r) {
    var e = $(this);
    r.title = e.find('.top-show-title a').text();
    r.url   = e.find('.top-show-title a').attr('href');
    r.image = e.find('.thumbnail').attr('data-src');
  })
  
  results('#serp-results td');
}

function results(selector) {
  paginate([
    {name: 'prev', url: 'prevPage'},
    {name: 'next', url: 'nextPage'},
  ])
  
  $(selector).list(function(r) {
    var e = $(this);
    var title = e.find('.show-title-gray,.show-title-container a.beaconid');
    var thumb = e.find('.thumbnail');
    
    r.title = title.text();
    r.url   = title.attr('href');
    r.image = thumb.attr('data-src') || thumb.attr('src');
  });
  
  paginate([
    {name: 'prev', url: 'prevPage'},
    {name: 'next', url: 'nextPage'},
  ])
}

function searchForm() {
  var value = $('#video_search_term').val();
  
  form('doSearch', function(f) {
    
    f.br();
    f.fieldset(function() {
      f.search('q', {placeholder: 'Hulu Search', value: value});
    })
    
  });
}

function doSearch(request) {
  $('#video_search_term').val(request.params.q);
  $('#search_form').submit();
  wait();
}
