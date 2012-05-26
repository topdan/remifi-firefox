###
//
// @import lib/std
// @domain movies.netflix.com
// @home.title netflix
// @home.pos  3
// @home.url  http://www.netflix.com
// @home.img  netflix.png
//
###

route "/WiHome", "index", ->
  action "doSearch"

route '/WiRecentAdditions', 'movies'

route /\/(Wi)?Search/, "search", ->
  action "doSearch"

route '/Queue', 'instantQueue', ->
  action "doSearch"

route /^\/(Wi)?Movie/i, 'movie', ->
  action 'selectSeason'

route /\/(Wi)?RoleDisplay/, 'roleDisplay'

route '/Quac', 'moreLike'

route '/WiPlayer', 'watch', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  action 'toggleHD'

this.roleDisplay = (request) ->
  title($('#page-title').text())
  
  $('.agMovie').list (r) ->
    r.image = $(this).find('.boxShotImg').attr('src')

this.index = (request) ->
  searchForm()
  
  list [
    { title: "My Instant Queue", url: "http://movies.netflix.com/Queue?qtype=ED" },
    { title: "New Arrivals", url: "http://movies.netflix.com/WiRecentAdditions" },
    { title: "Suggestions for You", url: "http://movies.netflix.com/RecommendationsHome" },
  ]
  
  # throw $('.agMovie').length
  movies(request)

this.searchForm = () ->
  value = $('#searchField').val()
  value = "" if value == "Movies, TV shows, actors, directors, genres"
  
  form 'doSearch', (f) ->
    f.br()
    f.fieldset ->
      f.search('q', {placeholder: 'Netflix Search', value: value})

this.doSearch = (request) ->
  $('#searchField').val(request.params.q)
  $('#global-search').submit()
  wait()

this.search = (request) ->
  searchForm()
  
  $('#searchResultsPrimary .mresult').list (r) ->
    e = $(this)
    
    r.title = e.find('.mdpLink').text()
    r.url   = e.find('.mdpLink').attr('href')
    r.image = e.find('img').attr('src')
  
  paginate [
    {name: 'prev', url: $('.prev').attr('href')},
    {name: 'next', url: $('.next').attr('href')},
  ]

this.instantQueue = (request) ->
  title("Recently Watched")
  $('#athome tbody tr').list (r) ->
    e = $(this)
    
    r.title = e.find('.title a').text()
    r.url   = e.find('.title a').attr('href')
  
  title("Instant Queue")
  $('#queue tbody tr').list (r) ->
    e = $(this)
    r.title = e.find('.title a').text()
    r.url   = e.find('.title a').attr('href')
  , perPage: 100

this.movie = (request) ->
  title $('h2').text()
  info $('.synopsis').text()
  
  button "Play", externalURL($('#displaypage-overview-image a').attr('href')), type: 'primary'
  
  $('#displaypage-overview-details .actions a').each ->
    text = $(this).text()
    text = "Add to Instant Queue" if text == "Instant Queue"
    
    button text, externalURL($(this).attr('href'))
  
  seasons(request)
  episodes(request)
  br()
  
this.seasons = (request) ->
  $('#seasonsNav li').list (r, i) ->
    r.title = "Season " + $(this).find('a').text()
    r.active = $(this).hasClass('selected')
    r.url = 'selectSeason?num=' + i
  , internalURL: true

this.selectSeason = (request) ->
  e = $('#seasonsNav li a').get(request.params['num'])
  clickOn $(e)
  wait ms: 500

this.episodes = (request) ->
  $('#episodeColumn li').list (r) ->
    r.title = $(this).find('.episodeTitle').text()
    r.url   = $(this).find('.btn-play').attr('data-vid') || $(this).find('.btn-play').attr('href')

this.moreLike = (request) ->
  title $('h3').text()

  button 'Move to position #1', $('.queueMoveToTop a').attr('href')
  movieSet(request)

this.movies = (request) ->
  $('.agMovie').list (r) ->
    r.title = $(this).find('.title a').text()
    r.url   = $(this).find('.title a').attr('href')
    r.image = $(this).find('.boxShot img').attr('src')

this.movieSet = (request) ->
  $('.agMovieSet .agMovie').list (r) ->
    r.title = $(this).find('.title a').text()
    r.url   = $(this).find('.title a').attr('href')
    r.image = $(this).find('.boxShot img').attr('src')

this.watch = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  toggle 'Is HD?', 'toggleHD', @isHD()

this.isHD = (requet) ->
  request.anchor != 'notHD'

this.toggleHD = (request) ->
  anchorIndex = document.location.href.indexOf('#')
  if anchorIndex == -1
    urlWithoutAnchor = document.location.href
  else
    urlWithoutAnchor = document.location.href.substring(0, anchorIndex)
  
  if request.anchor == 'notHD'
    request.anchor = 'HD'
    document.location.href = "#{urlWithoutAnchor}#HD"
  else
    request.anchor = 'notHD'
    document.location.href = "#{urlWithoutAnchor}#notHD"

this.player = () ->
  player = new Player('#SLPlayerWrapper')

  if @isHD()
    if player.isFullscreen
      player.setBox width: 1150, align: 'middle', height: 167
    else
      player.setBox width: 1115, align: 'middle', height: 125
  
  else if player.isFullscreen
    player.setBox width: 960, align: 'middle', height: 115
  else
    player.setBox width: 845, align: 'middle', height: 115

  player.setPlay x: 25, y: 25, delay: 500
  player.setFullscreenOn  align: 'right', x: 30, y: 25, delay: 500
  player.setFullscreenOff align: 'right', x: 30, y: 25, delay: 500

  player
