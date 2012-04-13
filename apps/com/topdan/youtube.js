//
// @import lib/all
// @url    http://www.youtube.com
//
this.header = "YouTube"

route("/", "index", function() {
  action("doSearch");
});

route("/results", "results", function() {
  action("doSearch");
})

route("/watch", "watch", function() {
  action('playPause');
  action('startOver');
  action('toggleFullscreen');
});

function index(request) {
  searchForm();
  
  var results = [];
  $('.feed-item-main').each(function() {
    var e = $(this);
    var link = e.find('h4 a');
    var img = e.find('.feed-item-thumb img');
    
    results.push({
      title: link.text(),
      url:   externalURL(link.attr('href')),
      image: externalURL(img.attr('data-thumb') || img.attr('src'))
    });
  });
  
  list(results);
}

function results(request) {
  var pages = [
    {name: 'prev', url: externalURL($('#search-footer-box .yt-uix-pager-prev').attr('href'))},
    {name: 'next', url: externalURL($('#search-footer-box .yt-uix-pager-next').attr('href'))}
  ];
  
  searchForm();
  paginate(pages);
  
  var results = [];
  $('#search-results > div.result-item').each(function() {
    var e = $(this);
    var link = e.find('h3 a');
    var img = e.find('.thumb-container img');
    results.push({
      title: link.text(),
      url:   externalURL(link.attr('href')),
      image: externalURL(img.attr('data-thumb') || img.attr('src'))
    });
  });
  
  list(results);
  paginate(pages);
}

function searchForm() {
  form('doSearch', function(f) {
    
    f.br();
    f.fieldset(function() {
      f.search('q', {placeholder: 'YouTube Search', value: $('#masthead-search-term').val()});
    })
    
  });
}

function doSearch(request) {
  document.location.href = 'http://www.youtube.com/results?search_query=' + encodeURIComponent(request.params.q);
  wait();
}

function watch(request) {
  var color = player().isFullscreen ? 'primary' : null
  title($('#eow-title').attr('title'));
  button('Play/Pause', 'playPause');
  button('Toogle Fullscreen', 'toggleFullscreen', {type: color});
  if (player().isFullscreen)
    button('Start Over', 'startOver', {disabled: 'Exit fullscreen first'});
  else
    button('Start Over', 'startOver');
  
  var results = [];
  $('#watch-related > .video-list-item').each(function() {
    var e = $(this);
    var img = e.find('.clip-inner img');
    results.push({
      title: e.find('.title').text(),
      url:   externalURL(e.find('a').attr('href')),
      image: externalURL(img.attr('data-thumb') || img.attr('src'))
    });
  });
  
  list(results);
}

function player() {
  var player = new Player('#movie_player-flash,#movie_player,#movie_player-html5');
  
  if (player.isFullscreen) {
    player.setBox({width: 'full', valign: 'bottom', height: 40});
    player.setSeek({x1: 5, x2: player.box.width, y: 0, delay: 500})
    player.setPlay({x: 35, y: 26, delay: 500});
  } else {
    player.setBox({width: 'full', valign: 'bottom', height: 35});
    player.setSeek({x1: 3, x2: player.box.width, y: 5, delay: 250})
    player.setPlay({x: 29, y: 25});
  }
  
  player.setFullscreenOff({key: 'escape'})
  player.setFullscreenOn({align: 'right', x: 17, y: 23})
  
  return player;
}

function playPause(request) {
  player().play();
  watch(request);
}

function startOver(request) {
  player().seek(0);
  watch(request);
}

function toggleFullscreen(request) {
  player().toggleFullscreen();
  watch(request);
}
