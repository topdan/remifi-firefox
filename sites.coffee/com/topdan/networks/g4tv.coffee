###
//
// @import lib/std
// @domain www.g4tv.com
//
###

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  
this.tryVideo = (request) ->
  return unless $('#video .primary-player').length > 0
  video(request)
  
this.video = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#video .primary-player', scrollY: 50)

  if player.isFullscreen
    player.setPlay valign: 'bottom', x: 215, y: 95, delay: 500
  else
    player.setBox width: 'full', valign: 'bottom', height: 20
    player.setPlay x: 25, y: 10, delay: 500
    player.setFullscreenOn align: 'right', x: 105, y: 10, delay: 500

  player
