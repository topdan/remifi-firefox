###
//
// @import lib/std
// @domain revision3.com
//
###

route '/', 'index', ->
  action 'doSearch'

route '/shows', 'shows'

route /^\/[^\/]+$/, 'show'

route /^\/search\//, 'search'

route /^\/[^\/]+\/[^\/]+$/, 'video', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  action 'previousVideo'
  action 'nextVideo'

this.index = (request) ->
  searchForm()
  
  $('.navigation > ul > li').list (r) ->
    r.title = $(this).find('a').text()
    r.url   = $(this).find('a').attr('href')
    
  $('#homePromos li').list (r) ->
    r.title = $(this).find('img').attr('alt') || ""
    r.title = r.title.substring("Promo image: ".length) if r.title.indexOf("Promo image: ") == 0
    
    r.url   = $(this).find('a').attr('href')
    r.image = $(this).find('.logo img').attr('src')

this.shows = (request) ->
  $('#shows li').list (r) ->
    r.title = $(this).find('h3').text()
    r.url   = $(this).find('a').attr('href')
    r.image = $(this).find('img').attr('src')

this.show = (request) ->
  title $('title').text()
  
  $('#eps-just-released .episode-list-container tbody tr').list (r) ->
    r.title = $(this).find('.title').text()
    r.url   = $(this).find('a').attr('href')

this.search = (request) ->
  searchForm()
  
  $('.videos .video').list (r) ->
    r.title = $(this).find('.title').text()
    r.url   = $(this).find('a').attr('href')
    r.image = $(this).find('img').attr('src')
  
this.doSearch = (request) ->
  $('#searchField').val(request.params['q']).parents('form').submit()
  wait()

this.searchForm = (request) ->
  q = $('#searchField,#bigSearch').val()
  q = "" if q == 'Enter search term'
  
  form 'doSearch', (f) ->
    f.br()
    f.fieldset ->
      f.search 'q', placeholder: 'Revision3 Search', value: q

this.video = (request) ->
  title $('title').text()
  
  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  paginate [
    {name: 'prev', url: 'previousVideo'},
    {name: 'next', url: 'nextVideo'},
  ]

this.previousVideo = (request) ->
  clickOn $('#prevEpisodeButton')
  wait()

this.nextVideo = (request) ->
  clickOn $('#nextEpisodeButton')
  wait()

this.player = () ->
  player = new Player('#rev3-player')

  player.setBox({width: 'full', valign: 'bottom', height: 40})
  if player.isFullscreen
    player.setPlay({x: 35, y: 26, delay: 500})
  else
    player.setPlay({x: 31, y: 21, delay: 500})

  player.setFullscreenOff({key: 'escape'})
  player.setFullscreenOn({align: 'right', valign: 'bottom', x: 99, y: 13, delay: 500})

  player
