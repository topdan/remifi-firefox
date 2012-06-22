###
//
// @import lib/std
// @domain vod.fxnetworks.com
//
###

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  
this.tryVideo = (request) ->
  return unless $('#videoPlayer').length > 0
  video(request)
  
this.video = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#videoPlayer')

  if player.isPaused && !player.isFullscreen
    player.setPlay x: 100, y: 130
    
  else if player.isFullscreen
    player.setPlay valign: 'bottom', x: (screen.width - 400) / 2 - 64, y: 20, delay: 500
    
  else
    player.setPlay valign: 'bottom', x: 64, y: 70, delay: 500
    player.setFullscreenOn valign: 'bottom', x: 610, y: 255, delay: 500

  player
