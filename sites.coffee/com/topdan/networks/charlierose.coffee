###
//
// @import lib/std
// @domain www.charlierose.com
//
###

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  
this.tryVideo = (request) ->
  return unless $('#container embed').length > 0
  video(request)
  
this.video = (request) ->
  player = this.player()
  
  toggle 'Fullscreen', 'toggleFullscreen', player.isFullscreen
  
  unless player.isFullscreen
    button 'Play/Pause', 'playPause'
  
this.player = ->
  player = new Player('#container embed')

  player.setBox width: 'full', valign: 'bottom', height: 190
  player.setPlay x: 15, y: 10, delay: 500
  player.setFullscreenOn x: 430, y: 20, delay: 500

  player
