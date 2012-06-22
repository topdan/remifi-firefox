###
//
// @import lib/std
// @domain espn.go.com
//
###

route /^\/watchespn\/index/, "index", ->
  action 'selectChannel'

route //, 'tryChannel', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

this.index = (request) ->
  $('#live-tabcontent td.event a.watchable').list (r,i) ->
    r.title = $(this)
    r.url = "selectChannel?num=#{i}"
  , internalURL: true

this.selectChannel = (request) ->
  num = request.params.num
  num = parseInt(num) if num
  
  shows = $('#live-tabcontent td.event a.watchable')
  clickOn $(shows.get(num))

this.tryChannel = (request) ->
  return unless $('#e3p-flash-title .e3p-flash-spacer').length > 0
  video(request)

this.video = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen

this.player = ->
  player = new Player('#e3p-flash-title .e3p-flash-spacer')

  if player.isFullscreen
    player.setPlay x: -240, y: 20, delay: 500, hide: false
  else
    player.setBox width: 'full', valign: 'bottom', height: 80
    player.setPlay x: -240, y: 20, delay: 500, hide: false
    player.setFullscreenOn x: 500, y: 20, delay: 500, hide: false
  
  player
