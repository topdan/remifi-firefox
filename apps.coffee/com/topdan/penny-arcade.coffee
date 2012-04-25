###
//
// @import lib/std
// @domain penny-arcade.com
//
###

route '/patv', 'patv'
route /^\/patv\/show\/[^\/]+$/, 'show', ->
  action 'selectSeason'
route /^\/patv\/episode\/[^\/]+$/, 'episode', ->
  action 'playPause'
  action 'toggleFullscreen'

this.patv = (request) ->
  title $('title')
  
  title 'Featured'
  $('#videoTabs li').list (r) ->
    a = $(this).find('h3 a')
    href = a.attr('href')
    
    if href
      r.title = a
      r.subtitle = $(this).find('p')
      r.url = $(href).find('a')
  
  title 'Current Shows'
  $('#shows li').list (r) ->
    r.titleURL = $(this).find('h2 a')
    r.image = $(this).find('img')

this.show = (request) ->
  title $('h2')
  info $('.info')
  
  currentTab = null
  
  $('#tabs .subTitle li').list (r, i) ->
    r.title = $(this).find('a')
    r.url = "selectSeason?num=#{i}"
    if $(this).hasClass('ui-state-active')
      r.active = true
      currentTab = $(this).find('a').attr('href')
  , internalURL: true
  
  $("#{currentTab} .episodes li").list (r) ->
    r.title = $(this).find('p a strong').text()
    r.url = $(this).find('a')
    r.image = $(this).find('img')
    r.subtitle = $(this).find('p a').text().substring(r.title.length)

this.selectSeason = (request) ->
  index = parseInt request.params['num']
  $('#tabs .subTitle li').each (i) ->
    clickOn $(this).find('a') if index == i
  wait ms: 1000

this.episode = (request) ->
  title $('h2')
  
  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  paginate [
    {name: 'prev', url: externalURL($('.btnPrev').attr('href'))},
    {name: 'next', url: externalURL($('.btnNext').attr('href'))},
  ]
  
  button 'More Episodes', $('.btnViewAll').attr('href')

this.player = () ->
  player = new Player('#player')

  player.setBox({width: 'full', valign: 'bottom', height: 30})
  player.setPlay({x: 19, y: 16})
  player.setFullscreenOff({key: 'escape'})
  player.setFullscreenOn({align: 'right', x: 65, y: 15})

  player

this.playPause = (request) ->
  player().play()
  episode(request)

this.toggleFullscreen = (request) ->
  player().toggleFullscreen()
  episode(request)
