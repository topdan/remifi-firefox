###
//
// @import lib/std
// @domain www.ted.com
//
###

route '/', 'index', ->
  action 'doSearch'
  action 'selectGrid'

route '/search', 'search'
route /^\/talks\//, 'talk', ->
  action 'playPause'
  action 'toggleFullscreen'

route /^\/speakers\//, 'speaker'
route /^\/themes\//, 'theme'

this.index = (request) ->
  title $('title').text()
  
  searchForm()
  
  br()
  button "Surprise Me", $('#surpriseMe').attr('href'), type: 'info'
  br()
  
  $('#grid li').list (r) ->
    label = $(this).find('label')
    r.title = label.text()
    r.url   = 'selectGrid?type=' + label.attr('for')
  , internalURL: true
  
  $('#theAppContainer .gridTile').list (r) ->
    r.title = $(this).find('.overlayText').text()
    r.url = $(this).find('a').attr('href')
    r.image = $(this).find('img.gridTileImage').attr('src')
  , wrap: true

this.selectGrid = (request) ->
  clickOn $('#' + request.params['type'])
  wait ms: 2000

this.searchForm = () ->
  form 'doSearch', (f) ->
    f.br()
    f.fieldset ->
      f.search('q', {placeholder: 'TED Search', value: $('#search_field').val()})

this.doSearch = (request) ->
  $('#search_field').val(request.params['q']).parents('form').submit()
  wait()

this.search = (request) ->
  $('dt').list (r) ->
    r.title = $(this).find('a').text()
    r.url = $(this).find('a').attr('href')
  , wrap: true

this.talk = (request) ->
  title $('title').text()
  
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  $('.relatedTalks dl').list (r) ->
    r.title = $(this).find('h4').text()
    r.url = $(this).find('a').attr('href')
    r.image = $($(this).find('img').get(1)).attr('src')
  , wrap: true

this.speaker = (request) ->
  $('#contextual dl.box').list (r) ->
    r.title = $(this).find('h4').text()
    r.url = $(this).find('a').attr('href')
    r.image = $($(this).find('img').get(1)).attr('src')
  , wrap: true

this.theme = (request) ->
  $('.talkMedallion').list (r) ->
    r.title = $(this).find('h4').text()
    r.url = $(this).find('a').attr('href')
    r.image = $($(this).find('img').get(1)).attr('src')
  , wrap: true

this.player = () ->
  player = new Player('#streamingPlayerSWF')
  player.setPlay({x: 42, y: 58, valign: 'bottom'})
  player.setFullscreenOff({key: 'escape'})
  player.setFullscreenOn({align: 'right', x: 23, y: 17})
  player

this.playPause = (request) ->
  player().play()
  talk(request)

this.toggleFullscreen = (request) ->
  player().toggleFullscreen()
  talk(request)
