###
//
// @import lib/std
// @domain www.nbc.com
//
###

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  action 'size', on: 'player'
  
this.tryVideo = (request) ->
  return unless $('#scet-main-video').length > 0
  video(request)
  
this.video = (request) ->
  button 'Play/Pause', 'playPause'
  button 'Size', 'size'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#scet-main-video')

  player.setFullscreenOn align: 'right', valign: 'bottom', x: 65, y: 190, delay: 500

  if player.isFullscreen
    height = 65
  else
    height = 20
  
  player.setBox width: 'full', valign: 'bottom', height: height
  player.setPlay x: 20, y: 10, delay: 500
  
  player.addButton 'size', align: 'right', x: 65, y: 10

  player
