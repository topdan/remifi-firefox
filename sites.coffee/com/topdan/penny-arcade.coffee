###
//
// @import lib/std
// @domain penny-arcade.com
// @home.title patv
// @home.pos  11
// @home.url  http://penny-arcade.com
// @home.img  penny-arcade.png
//
###

route '/patv', 'patv'
route /^\/patv\/show\/[^\/]+$/, 'show', ->
  action 'selectSeason'
route /^\/patv\/episode\/[^\/]+$/, 'episode', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

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
  
  linkTo 'More Episodes', $('.btnViewAll').attr('href')
  
  if $('#iconNotes a').length > 0
    title 'Episode Notes'
    
    $('#iconNotes a').list (r) ->
      r.titleURL = $(this)
      r.mobile = true
  
  else if $('#iconNotes li').length > 0
    title 'Episode Notes'
    
    $('#iconNotes li').list (r) ->
      r.title = $(this)
  
  if $('#iconMusic a').length > 0
    title 'Like the music?'
    
    $('#iconMusic a').list (r) ->
      r.titleURL = $(this)
      r.mobile = true
    
  
this.player = () ->
  player = new Player('#player')

  player.setBox({width: 'full', valign: 'bottom', height: 30})
  player.setPlay({x: 19, y: 16})
  player.setFullscreenOn({align: 'right', x: 65, y: 15})

  player
