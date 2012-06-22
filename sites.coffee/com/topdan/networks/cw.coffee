###
//
// @import lib/std
// @domain www.tbs.com
//
###

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  
this.tryVideo = (request) ->
  return unless $('#videoMid').length > 0
  video(request)
  
this.video = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#videoMid')

  player.setBox width: 'full', valign: 'bottom', height: 27
  player.setPlay x: 17, y: 15, delay: 500
  player.setFullscreenOn align: 'right', x: 70, y: 15, delay: 500

  player
