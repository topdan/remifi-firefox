###
//
// @import lib/std
// @domain www.spike.com
//
###

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  
this.tryVideo = (request) ->
  return unless $('.player').length > 0
  video(request)
  
this.video = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('.player', scrollY: 50)

  player.setBox width: 'full', valign: 'bottom', height: 37
  player.setPlay x: 25, y: 19, delay: 500
  player.setFullscreenOn align: 'right', x: 25, y: 25, delay: 500

  player
