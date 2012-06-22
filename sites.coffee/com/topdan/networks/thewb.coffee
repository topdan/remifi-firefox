###
//
// @import lib/std
// @domain www.thewb.com
//
###

route /^\/shows\/[^\/]+\/[^\/]+\/[^\/]+/, 'video', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  

this.video = (request) ->
  title $('h3 .episode').text()
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#ds_player')

  player.setBox width: 'full', valign: 'bottom', height: 50
  player.setPlay x: 25, y: 25, delay: 500
  player.setFullscreenOn align: 'right', x: 100, y: 25, delay: 500
  
  player
