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

function watch(request) {
  title($('#eow-title').attr('title'));
  button('Play/Pause', 'playPause');
  button('Start Over', 'startOver');
  button('Toogle Fullscreen', 'toggleFullscreen');
}

function player() {
  var player = new Player('#movie_player-flash');
  
  player.setBox({width: 'full', valign: 'bottom', height: 35});
  player.setPlay({x: 28, y: 25});
  
  player.setFullscreenOff({key: 'escape'})
  player.setFullscreenOn({align: 'right', x: 17, y: 23})
  
  if (player.isFullscreen)
    player.setSeek({x1: 0, x2: player.box.width, y: 0})
  else
    player.setSeek({x1: 3, x2: player.box.width, y: 0})
  
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
  searchForm();
  
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
}

function searchForm() {
  form('doSearch', function(f) {
    
    f.br();
    f.fieldset(function() {
      f.search('q', {placeholder: 'YouTube Search', value: $('#masthead-search-term').val()});
    })
    f.br();
    
  });
}

function doSearch(request) {
  document.location.href = 'http://www.youtube.com/results?search_query=' + encodeURIComponent(request.params.q);
  wait();
}
