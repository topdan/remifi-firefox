###
//
// @import lib/std
// @domain www.remifi.com
// @domain remifi.com
// @domain remifi.herokuapp.com
// @domain remifi.com.local
//
###

route '/', 'index', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

this.index = -> 
  button 'Subscribe', externalURL('/subscribe.html'), type: 'primary'
  
  if $('#demo-video').length > 0
    button 'Play/Pause', 'playPause'
    toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  $('#extra-reading .span4').list (r) ->
    r.titleURL = $(this).find('a')
    r.mobile = true

this.player = () ->
  vimeo = new Player('#demo-video')
  
  vimeo.setBox width: 'full', valign: 'bottom', height: 42
  vimeo.setPlay x: 41, y: 20, delay: 500
  vimeo.setFullscreenOn align: 'right', valign: 'bottom', x: 99, y: 26, delay: 500
  
  vimeo