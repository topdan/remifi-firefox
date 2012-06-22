###
//
// @import lib/std
// @domain www.5secondfilms.com
// @domain 5secondfilms.com
// @home.title 5s films
// @home.pos  18
// @home.url  http://www.5secondfilms.com
// @home.img  5secondfilms.png
//
###

route '/', 'index', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  action 'nextVideo'
  action 'prevVideo'
  action 'openVideo'
  action 'openTab'

route /\/watch\/[^\/]+/, 'index', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  action 'nextVideo'
  action 'prevVideo'
  action 'openVideo'
  action 'openTab'

this.index = (request) -> 
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  if $('#nextFilmArrow').length > 0
    paginate [
     {name: 'prev', url: 'prevVideo'},
     {name: 'next', url: 'nextVideo'}
    ]
  
  $('#filmCarouselTabs li').list (r, i) ->
    r.title = $(this).find('a')
    r.url = "openTab?i=#{i}"
    r.active = $(this).hasClass('active')
  , internalURL: true
  
  $('#filmCarouselList li').list (r, i) ->
    r.title = $(this).attr('data-filmtitle')
    r.url = "openVideo?i=#{i}"
    r.image = $(this).find('img')
  , internalURL: true

this.nextVideo = ->
  clickOn $('#nextFilmArrow'), actual: true

this.prevVideo = ->
  clickOn $('#prevFilmArrow'), actual: true

this.openVideo = (request) ->
  i = request.params.i
  if i
    i = parseInt(i)
    e = $('#filmCarouselList li').get(i)
    clickOn $(e)
    wait ms: 2000

this.openTab = (request) ->
  i = request.params.i
  if i
    i = parseInt(i)
    e = $('#filmCarouselTabs li a').get(i)
    clickOn $(e)
    wait ms: 2000

this.player = () ->
  player = new Player('#entry-content,#filmContainer')
  
  player.setPlay x: 15, y: 15, valign: 'bottom'
  player.setFullscreenOn align: 'right', x: 25, y: 25, delay: 500
  
  player