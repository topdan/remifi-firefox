###
//
// @import lib/std
// @domain www.dailymotion.com
// @domain dailymotion.com
//
###

route /^\/video\//, 'video', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

this.video = (request) ->
  title $('h1 span').text()

  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  relatedVideos()

this.relatedVideos = ->
  $('.dmpi_list .column').list (r) ->
    r.titleURL = $(this).find('h3')
    r.image = $(this).find('img')

this.player = () ->
  player = new Player('.player_box')


  player.setBox width: 'full', valign: 'bottom', height: 40

  player.setPlay x: 26, y: 23, delay: 500
  player.setFullscreenOn align: 'right', x: 26, y: 23, delay: 500

  player
