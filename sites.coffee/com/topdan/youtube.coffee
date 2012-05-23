###
//
// @import lib/std
// @import com.topdan.youtube.player
// @domain www.youtube.com
// @home.title youtube
// @home.pos  2
// @home.url  http://www.youtube.com
// @home.img  youtube.png
//
###

route "/", "index", ->
  action "doSearch"

route "/results", "results", ->
  action "doSearch"

route "/watch", "watch", ->
  action 'playPause', on: 'player'
  action 'startOver', on: 'player'
  action 'toggleFullscreen', on: 'player'

route /\/user\/[^\/]+$/, 'user'
route /\/user\/[^\/]+\/videos$/, 'userVideos'

route '/playlist', 'playlist'

this.index = (request) ->
  searchForm()
  
  $('.feed-item-main').list (r) ->
    e = $(this)
    link = e.find('h4 a')
    img = e.find('.feed-item-thumb img')
    
    r.title = link.text()
    r.url   = link.attr('href')
    r.image = img.attr('data-thumb') || img.attr('src')

this.results = (request) ->
  pages = [
    {name: 'prev', url: externalURL($('#search-footer-box .yt-uix-pager-prev').attr('href'))},
    {name: 'next', url: externalURL($('#search-footer-box .yt-uix-pager-next').attr('href'))}
  ]
  
  searchForm()
  paginate(pages)
  
  $('#search-results > div.result-item').list (r) ->
    e = $(this)
    link = e.find('h3 a')
    img = e.find('.thumb-container img')
    
    r.title = link.text()
    r.url   = link.attr('href')
    r.image = img.attr('data-thumb') || img.attr('src')

  paginate(pages)

this.searchForm = () ->
  form 'doSearch', (f) ->
    f.br()
    f.fieldset ->
      f.search('q', {placeholder: 'YouTube Search', value: $('#masthead-search-term').val()})

this.doSearch = (request) ->
  document.location.href = 'http://www.youtube.com/results?search_query=' + encodeURIComponent(request.params.q)
  wait()

this.playlist = (request) ->
  title $('h1')

  $('.playlist-video-item').list (r) ->
    r.title = $(this).find('.title')
    r.url   = $(this).find('a')
    r.image = $(this).find('img').attr('data-thumb') || $(this).find('img').attr('src')

this.user = (request) ->
  title $('h1')

  try
    player().controls()

  linkTo 'Playlists', externalURL("#{request.path}/videos?view=1")
  
  $('li.video').list (r) ->
    r.titleURL = $(this).find('h3 a')
    r.image = $(this).find('img').attr('data-thumb') || $(this).find('img').attr('src')

this.userVideos = (request) ->
  title $('h1')

  $('.playlist').list (r) ->
    r.title = $(this).find('a span')
    r.url   = $(this).find('a')
    r.image = $(this).find('img')

this.watch = (request) ->
  title($('#eow-title').attr('title'))
  
  unavailable = $('#unavailable-message')
  
  if unavailable.length > 0
    error(unavailable.find('.yt-alert-message').text())
  else
    player().controls()
  
  $('#watch-related > .video-list-item').list (r) ->
    e = $(this)
    img = e.find('img')
    
    r.title = e.find('.title').text()
    r.url   = e.find('a').attr('href')
    r.image = img.attr('data-thumb') || img.attr('src')

this.player = () ->
  new YouTubePlayer('#movie_player-flash,#movie_player,#movie_player-html5')
