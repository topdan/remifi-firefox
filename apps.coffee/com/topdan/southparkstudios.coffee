###
//
// @import lib/std
// @domain www.southparkstudios.com
//
###

route '/', 'index', ->
  action 'doSearch'

route '/full-episodes', 'fullEpisodes', ->
  action 'doSearch'

route /^\/full-episodes\/season-[^\/]+$/, 'season'
route /^\/full-episodes\/special$/, 'season'

route /^\/full-episodes\/.*/, 'episode', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

this.index = (request) ->
  if hasSearchResults()
    searchResults(request)
    return
  
  title "South Park"
  searchForm()
  linkTo "Watch Full Episodes"

this.fullEpisodes = (request) ->
  if hasSearchResults()
    searchResults(request)
    return
  
  searchForm()
  button "Watch Random Episode", $('#randomep').attr('href')
  
  $('a.seasonbtn').list (r) ->
    r.url = $(this).attr('href')
    
    i = parseInt($(this).text())
    if isNaN(i)
      r.title = $(this).text()
    else
      r.title = "Season #{i}"

this.hasSearchResults = ->
  $('.search_results .search_entry').length > 0

this.searchResults = (request) ->
  searchForm()
  
  $('.search_results .search_entry').list (r) ->
    r.titleURL = $(this).find('h3 a')
    r.image = $(this).find('img')
    r.subtitle = $(this).find('.searchEpisodeDescription')

this.searchForm = () ->
  form 'doSearch', (f) ->
    f.br()
    f.fieldset ->
      f.search('q', {placeholder: 'Search', value: $('#epsearchterm').val()})

this.doSearch = (request) ->
  $('#epsearchterm').val(request.params.q).parents('form').submit()
  wait ms: 500

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

this.player = () ->
  player = new Player('#mtvnPlayer')

  player.setBox({width: 'full', valign: 'bottom', height: 40})
  player.setPlay({x: 24, y: 25, delay: 500})
  player.setFullscreenOn({align: 'right', x: 17, y: 23})

  player
