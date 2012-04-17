//
// @import lib/all
// @url    http://www.youtube.com
//

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
  
  $('.feed-item-main').list(function(r) {
    var e = $(this);
    var link = e.find('h4 a');
    var img = e.find('.feed-item-thumb img');
    
    r.title = link.text();
    r.url   = link.attr('href');
    r.image = img.attr('data-thumb') || img.attr('src');
  });
}

function results(request) {
  var pages = [
    {name: 'prev', url: externalURL($('#search-footer-box .yt-uix-pager-prev').attr('href'))},
    {name: 'next', url: externalURL($('#search-footer-box .yt-uix-pager-next').attr('href'))}
  ];
  
  searchForm();
  paginate(pages);
  
  $('#search-results > div.result-item').list(function(r) {
    var e = $(this);
    var link = e.find('h3 a');
    var img = e.find('.thumb-container img');
    
    r.title = link.text();
    r.url   = link.attr('href');
    r.image = img.attr('data-thumb') || img.attr('src');
  });
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
  title($('#eow-title').attr('title'));
  
  var unavailable = $('#unavailable-message');
  
  if (unavailable.length > 0) {
    error(unavailable.find('.yt-alert-message').text());
    
  } else {
    var p = player();
    var color = player().isFullscreen ? 'primary' : null
    button('Play/Pause', 'playPause');
    button('Toogle Fullscreen', 'toggleFullscreen', {type: color});
    if (player().isFullscreen)
      button('Start Over', 'startOver', {disabled: 'Exit fullscreen first'});
    else
      button('Start Over', 'startOver');
  }
  
  $('#watch-related > .video-list-item').list(function(r) {
    var e = $(this);
    var img = e.find('.clip-inner img');
    
    r.title = e.find('.title').text();
    r.url   = e.find('a').attr('href');
    r.image = img.attr('data-thumb') || img.attr('src');
  });
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
