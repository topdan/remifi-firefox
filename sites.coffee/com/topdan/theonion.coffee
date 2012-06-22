###
//
// @import lib/std
// @domain www.theonion.com
//
###

route /^\/video\//, 'video', ->
  action 'playPause', on: 'player'

this.video = (request) ->
  title $('h2 a').text()
  button('Play/Pause', 'playPause')

this.player = ->
  player = new Player('#player_wrapper iframe')

  player.setBox width: 'full', valign: 'bottom', height: 40
  player.setPlay x: 20, y: 20, delay: 500
  
  player
  