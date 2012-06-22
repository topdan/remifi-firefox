###
//
// @import lib/std
// @domain www.cbs.com
//
###

route //, 'tryVideo', ->
  action 'continue', on: 'player'
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

this.tryVideo = (request) ->
  return unless $('#cbs-video-player-wrapper').length > 0
  video(request)

this.video = (request) ->
  button 'Continue', 'continue'
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#flashcontent')

  player.addButton 'continue', x: 5, y: 10
  player.setFullscreenOn valign: 'bottom', x: 520, y: 50, delay: 1000
  
  if player.isFullscreen
    player.setPlay valign: 'bottom', x: (screen.width - 540) / 2 + 15, y: 50, delay: 1000
  else
    player.setPlay valign: 'bottom', x: 138, y: 50, delay: 1000
  
  
  player
