###
//
// @import lib/std
// @domain www.collegehumor.com
// @domain collegehumor.com
// @home.title col humor
// @home.pos  16
// @home.url  http://www.collegehumor.com/videos
// @home.img  collegehumor.png
//
###

route /^\/videos?/, 'router', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

route /^\/embed/, 'router', ->
  action 'playPause', on: 'embeddedPlayer'
  action 'toggleFullscreen', on: 'embeddedPlayer'

this.router = (request) ->
  if $('#flash_player').length > 0
    video()
  else
    index()

this.index = (request) ->
  page 'index', ->
    linkTo 'categories', '#categories'
    mediaList()
  
  page 'categories', ->
    linkTo 'back', '#index'
    
    $('#sidebar_left li').list (r) ->
      r.titleURL = $(this).find('a')
      r.active = $(this).hasClass('selected')
      
    linkTo 'back', '#index'


this.video = (request) ->
  name = $('title').text()
  title name.substring(0, " - CollegeHumor Video".length)

  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  mediaList()

this.mediaList = ->
  $('.media_list .video').list (r) ->
    r.title = $(this).find('strong')
    r.url = $(this).find('a')
    r.image = $(this).find('img')
  
this.player = () ->
  player = new Player('#flash_player')


  player.setBox width: 'full', valign: 'bottom', height: 60

  player.setPlay x: 30, y: 16, delay: 500
  player.setFullscreenOn x: 620, y: 16, delay: 500

  player
  
this.embeddedPlayer = () ->
  player = new Player('#flash_player')
  
  if player.isFullscreen
    player.setBox width: 'full', valign: 'bottom', height: 30
  else
    player.setBox width: 'full', valign: 'bottom', height: 60

  player.setPlay x: 20, y: 20, delay: 500
  player.setFullscreenOn x: 620, y: 20, delay: 500

  player
