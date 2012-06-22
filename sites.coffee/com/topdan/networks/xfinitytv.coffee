###
//
// @import lib/std
// @domain xfinitytv.comcast.net
//
###

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  
this.tryVideo = (request) ->
  return unless $('#playerArea').length > 0
  video(request)
  
this.video = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#playerArea')

  player.setBox width: 'full', valign: 'bottom', height: 60
  player.setPlay x: 40, y: 20, delay: 500
  player.setFullscreenOn align: 'right', x: 40, y: 20, delay: 500

  player
