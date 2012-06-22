###
//
// @import lib/std
// @domain www.mtv.com
//
###

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  
this.tryVideo = (request) ->
  return unless $('#videoPlayerWrapper').length > 0
  video(request)
  
this.video = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#videoPlayerWrapper')

  player.setBox width: 'full', valign: 'bottom', height: 42
  player.setPlay x: 24, y: 22, delay: 500
  player.setFullscreenOn align: 'right', x: 24, y: 22, delay: 500

  player
