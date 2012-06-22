###
//
// @import lib/std
// @domain abc.go.com
//
###

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  
this.tryVideo = (request) ->
  return unless $('#abcvp2').length > 0
  video(request)
  
this.video = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#abcvp2')

  player.setBox width: 'full', valign: 'bottom', height: 45
  player.setPlay x: 30, y: 25, delay: 500
  player.setFullscreenOn align: 'right', x: 25, y: 25, delay: 500

  player
