###
//
// @import lib/std
// @domain www.collegehumor.com
// @domain collegehumor.com
//
###

route /^\/video\//, 'video', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

this.video = (request) ->
  name = $('title').text()
  title name.substring(0, " - CollegeHumor Video".length)

  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  mediaList()

this.mediaList = ->
  $('.media_list .video').list (r) ->
    r.title = $(this).find('strong')
    r.url = $(this).find('a')
    r.image = $(this).find('img')
  
this.player = () ->
  player = new Player('#flash_player')


  player.setBox width: 'full', valign: 'bottom', height: 60

  player.setPlay x: 30, y: 16, delay: 500
  player.setFullscreenOn x: 620, y: 16, delay: 500

  player
