###
//
// @import lib/std
// @domain www.funnyordie.com
// @domain funnyordie.com
// @home.title funny|die
// @home.pos  15
// @home.url  http://www.funnyordie.com
// @home.img  funnyordie.png
//
###

beforeFilter 'newsletter'
action 'closeNewsletter'

route '/', 'index'

route /^\/videos\//, 'video', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

route //, 'videos'

this.index = (request) ->
  linkTo 'videos', externalURL('/videos')
  allVideos(request)

this.allVideos = (request) ->
  $('.video_preview').list (r) ->
    r.titleURL = $(this).find('.details a')
    r.titleURL = $(this).find('a.title') if r.titleURL.length == 0
    
    r.image = $(this).find('img')
    r.imageWidth = 142
    r.imageHeight = 112
    r.subtitle = $(this).find('.users')

this.videos = (request) ->
  
  page 'index', ->
    linkTo 'categories', '#categories'
    allVideos()
  
  page 'categories', ->
    linkTo 'back', '#index'
    
    $('#secondary-items li a').list (r) ->
      r.titleURL = $(this)
      r.active = $(this).hasClass('current')
    
    linkTo 'back', '#index'
    
this.video = (request) ->
  
  title $('h1 a').text()

  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

  allVideos()

this.newsletter = (request) ->
  dialog = $('#newsletter_dialog')
  style = dialog.attr('style')
  
  if dialog.length > 0 && !(style == 'display: none;' || style == 'display:none')
    button 'close newsletter', 'closeNewsletter', type: 'primary'
    renderRoute(request)

this.closeNewsletter = ->
  clickOn $('#newsletter_dialog_close a')

this.player = () ->
  player = new Player('#video_player')

  
  if player.isFullscreen
    player.setBox width: 'full', valign: 'bottom', height: 42
  else
    player.setBox width: 'full', valign: 'bottom', height: 100

  player.setPlay x: 22, y: 22
  player.setFullscreenOn align: 'right', x: 22, y: 20

  player
