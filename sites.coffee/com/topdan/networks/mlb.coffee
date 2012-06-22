###
//
// @import lib/std
// @domain mlb.com
// @domain mlb.mlb.com
// @home.title mlb.com
// @home.pos  8
// @home.url  http://mlb.mlb.com/mediacenter/index.jsp
// @home.img  mlb.png
//
###

route '/mediacenter/index.jsp', 'mediacenter', ->
  action 'prevDay'
  action 'nextDay'

route '/video/play.jsp', 'clip', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  
this.mediacenter = (request) ->
  title $('#mediagrid-daypicker .bam-daypicker-toggle span')
  paginate [
    {name: 'prev', url: 'prevDay'},
    {name: 'next', url: 'nextDay'},
  ]

  count = 0
  $('#mediagrid-final tbody tr').list (r, i) ->
    e = $(this)
    game = e.find('.mediagrid-info-game li')
    if game.length == 2
      away = $(game.get(0)).text()
      home = $(game.get(1)).text()
      
      r.title = "#{away} at #{home}"
      r.url = e.find('.mediagrid-video-condensed a')
      count++
      
  if count == 0
    br()
    button 'no games? refresh', '/', type: 'primary'
    
this.prevDay = (request) ->
  clickOn $('#mediagrid-daypicker .bam-daypicker-previous')
  wait ms: 500
  
this.nextDay = (request) ->
  clickOn $('#mediagrid-daypicker .bam-daypicker-next')
  wait ms: 500

this.clip = (request) ->
  title $('#clipTitle')
  
  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  

this.player = () ->
  player = new Player('#featureBody')

  player.setBox width: 'full', valign: 'bottom', height: 35
  
  if player.isFullscreen
    player.setPlay x: 20, y: 20, delay: 500
    player.setFullscreenOn x: 20, y: 20, align: 'right', delay: 500
  else
    player.setPlay x: player.width / 2 - 300, y: 20, delay: 500
    player.setFullscreenOn x: player.width / 2 + 300, y: 20, delay: 500

  player
