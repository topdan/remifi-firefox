###
//
// @import lib/std
// @domain www.mydamnchannel.com
//
###

route '/', 'index'
route //, 'episode', ->
  action 'playPause'
  action 'toggleFullscreen'
  action 'seriesPrev'
  action 'seriesNext'

this.index = (request) ->
  title $('title')
  
  $('.slides .slide').list (r) ->
    r.title = $(this).find('span.title')
    r.url   = $(this).find('a')
    r.subtitle = $(this).find('.infoText')
  
  $('#channelNav div li').list (r) ->
    r.titleURL = $(this).find('a')
    r.image = $(this).find('img')

this.episode = (request) ->
  if request.anchor
    this.series(request)
  else
    this.show(request)

this.series = (request) ->
  title $("##{request.anchor}").parents('.seriesBrowse').find('h1')
  
  paginate [
    {name: 'prev', url: 'seriesPrev'},
    {name: 'next', url: 'seriesNext'},
  ]
  
  $("##{request.anchor} .videolist").list (r) ->
    r.title = $(this).find('h2')
    r.url   = $(this).find('a')
    r.image = $(this).find('img')
    r.subtitle = $(this).find('p')
  
  paginate [
    {name: 'prev', url: 'seriesPrev'},
    {name: 'next', url: 'seriesNext'},
  ]

this.seriesPrev = (request, index) ->
  index ||= 0
  if request.anchor
    nav = $("##{request.anchor}").parents('.seriespicker').find('.seriesNav a')
    clickOn $(nav.get(index)) if nav.length == 2
  wait ms: 1000
  
this.seriesNext = (request) ->
  seriesPrev request, 1
  
this.show = (request) ->
  return if $('.mejs-video').length == 0
  title $('h1')

  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  $('.seriesBrowse').list (r, i) ->
    id = $(this).find('.ui-carousel').attr('id')
    r.title = $(this).find('h1')
    r.url = "#{request.path}##{id}"
  
this.player = () ->
  player = new Player('.mejs-video')
  
  player.setBox({width: 'full', valign: 'bottom', height: 30})
  
  if player.isFullscreen
    player.setPlay({x: 19, y: 14, delay: 500})
  else
    player.setPlay({valign: 'bottom', x: 12, y: 19, delay: 500})
  
  player.setFullscreenOn({align: 'right', x: 12, y: 19})

  player

this.playPause = (request) ->
  player().play()
  episode(request)

this.toggleFullscreen = (request) ->
  player().toggleFullscreen()
  episode(request)
