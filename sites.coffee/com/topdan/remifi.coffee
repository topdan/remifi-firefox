###
//
// @import lib/std
// @domain www.remifi.com
// @domain remifi.com
// @domain remifi.dev
//
###

route '/', 'index', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

route /\/videos\//, 'video', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

this.index = -> 
  @video()
  
  $('#extra-reading .span4').list (r) ->
    r.titleURL = $(this).find('a')
    r.mobile = true

this.video = ->
  info $('.video-description')
  
  if $('#demo-video').length > 0
    button 'Play/Pause', 'playPause'
    toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
this.player = () ->
  vimeo = new Player('#demo-video')
  
  vimeo.setBox width: 'full', valign: 'bottom', height: 42
  vimeo.setPlay x: 41, y: 20, delay: 500
  vimeo.setFullscreenOn align: 'right', valign: 'bottom', x: 99, y: 26, delay: 500
  
  vimeo