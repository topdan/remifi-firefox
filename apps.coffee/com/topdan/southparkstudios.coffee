###
//
// @import lib/std
// @domain www.southparkstudios.com
//
###

route '/', 'index'
route '/full-episodes', 'fullEpisodes'
route /^\/full-episodes\/season-[^\/]+$/, 'season'
route /^\/full-episodes\/special$/, 'season'

route /^\/full-episodes\/.*/, 'episode', ->
  action 'playPause'
  action 'toggleFullscreen'

this.index = (request) ->
  title "South Park"
  button "Watch Full Episodes"

this.fullEpisodes = (request) ->
  button "Watch Random Episode", $('#randomep').attr('href')
  
  $('a.seasonbtn').list (r) ->
    r.url = $(this).attr('href')
    
    i = parseInt($(this).text())
    if isNaN(i)
      r.title = $(this).text()
    else
      r.title = "Season #{i}"

this.season = (request) ->
  $('.content_carouselwrap > ol > li').list (r) ->
    r.title = $(this).find('h5').text()
    r.url   = $(this).find('a').attr('href')
    r.image = $(this).find('a img').attr('src')
    r.active = request.url == externalURL(r.url)

this.episode = (request) ->
  t = $('title').text()
  title t.substring(0, t.length - " - Full Episode Player - South Park Studios".length)
  
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  season request

this.playPause = (request) ->
  player().play()
  episode(request)

this.toggleFullscreen = (request) ->
  player().toggleFullscreen()
  episode(request)

this.player = () ->
  player = new Player('#mtvnPlayer')

  player.setBox({width: 'full', valign: 'bottom', height: 40})
  player.setPlay({x: 24, y: 25, delay: 500})
  player.setFullscreenOff({key: 'escape'})
  player.setFullscreenOn({align: 'right', x: 17, y: 23})

  player
