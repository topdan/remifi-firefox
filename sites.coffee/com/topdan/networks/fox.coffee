###
//
// @import lib/std
// @domain www.fox.com
//
###

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  
this.tryVideo = (request) ->
  return unless $('#player').length > 0
  video(request)
  
this.video = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#player')

  if player.isPaused && !player.isFullscreen
    player.setPlay x: 115, y: 100
  else
    player.setBox width: 'full', valign: 'bottom', height: 45
    player.setFullscreenOn align: 'right', x: 25, y: 25, delay: 500
    player.setPlay x: 25, y: 25, delay: 500
  
  player
