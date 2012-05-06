###
//
// @import lib/std
// @domain www.hulu.com
//
###

route "/", "index", ->
  action "doSearch"

route "/search", "search", ->
  action "doSearch"
  action "prevPage"
  action "nextPage"

route /^\/browse/, 'browse', ->
  action "prevPage"
  action "nextPage"

route /^\/popular/, 'browse', ->
  action "prevPage"
  action "nextPage"

route /^\/recent/, 'browse', ->
  action "prevPage"
  action "nextPage"

route /^\/watch/, 'watch', ->
  action 'playPause'
  action 'toggleFullscreen'
  action 'loadMoreEpisodes'

route /^\/[^\/]+$/, 'tvShowOrMovie', ->
  action 'loadMoreEpisodes'

this.tvShowOrMovie = (request) ->
  if $('#full-episode-container,#episode-container').length > 0
    tvShow(request)
  else
    movie(request)

this.tvShow = (request) ->
  title($('meta[property="og:title"]').attr('content'))
  
  if $('#full-episode-container').length > 0
    baseId = '#full-episode-container'
  else
    baseId = '#episode-container'
  
  $("#{baseId} .vsl li").list (r) ->
    e = $(this)
    title = e.find('.video-info')
    thumb = e.find('.thumbnail')
    
    r.title = e.children('a.beaconid').text()
    r.url   = e.find('a').attr('href')
    r.image = thumb.attr('data-src') || thumb.attr('src')
    r.subtitle = title.text()
  
  nextUrl = 'loadMoreEpisodes' if $("#{baseId} .pages li.next").length > 0
  
  paginate([{name: 'next', url: nextUrl}])

this.loadMoreEpisodes = (request) ->
  if $('#full-episode-container').length > 0
    baseId = '#full-episode-container'
  else
    baseId = '#episode-container'
  
  elem = $("#{baseId} .pages li.next")
  clickOn(elem)
  wait ms: 500

this.movie = (request) ->

this.prevPage = (request) ->
  elem = $($('.page li').get(2)).find('a')
  clickOn(elem)
  wait ms: 500

this.nextPage = (request) ->
  elem = $($('.page li').get(6)).find('a')
  clickOn(elem)
  wait ms: 500

this.index = (request) ->
  searchForm()
  
  title "TV Shows"
  list [
    { title: "Most Popular", url: "http://www.hulu.com/browse/popular/tv?src=topnav" },
  ]
  
  title "TV Episodes"
  list [
    { title: "Most Popular", url: "http://www.hulu.com/popular/episodes?src=topnav" },
    { title: "Recently Added", url: "http://www.hulu.com/recent/episodes?src=topnav" }
  ]
  
  title "Movies"
  list [
    { title: "Most Popular", url: "http://www.hulu.com/popular/feature_films?src=topnav" },
    { title: "Recently Added", url: "http://www.hulu.com/recent/feature_films?src=topnav" }
  ]
  
  title "Trailers"
  list [
    { title: "Most Popular", url: "http://www.hulu.com/popular/film_trailers?src=topnav" },
    { title: "Recently Added", url: "http://www.hulu.com/recent/film_trailers?src=topnav" },
  ]

this.browse = (request) ->
  results('#videos-list td')

this.search = (request) ->
  searchForm()
  
  $('#show-page').list (r) ->
    e = $(this)
    r.title = e.find('.top-show-title a').text()
    r.url   = e.find('.top-show-title a').attr('href')
    r.image = e.find('.thumbnail').attr('data-src')
  
  results('#serp-results td')

this.results = (selector) ->
  paginate [
    {name: 'prev', url: 'prevPage'},
    {name: 'next', url: 'nextPage'},
  ]
  
  $(selector).list (r) ->
    e = $(this)
    title = e.find('.show-title-gray,.show-title-container a.beaconid')
    thumb = e.find('.thumbnail')
    
    r.title = title.text()
    r.url   = title.attr('href')
    r.image = thumb.attr('data-src') || thumb.attr('src')
  
  paginate [
    {name: 'prev', url: 'prevPage'},
    {name: 'next', url: 'nextPage'},
  ]

this.searchForm = () ->
  value = $('#video_search_term').val()
  
  form 'doSearch', (f) ->
    f.br()
    f.fieldset ->
      f.search('q', {placeholder: 'Hulu Search', value: value})

this.doSearch = (request) ->
  $('#video_search_term').val(request.params.q)
  $('#search_form').submit()
  wait()

this.watch = (request) ->
  button 'Play/Pause', 'playPause'
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  tvShowOrMovie(request)

this.playPause = (request) ->
  player().play()
  watch(request)

this.toggleFullscreen = (request) ->
  player().toggleFullscreen()
  watch(request)

this.player = () ->
  player = new Player('#player')

  player.setBox({width: 'full', valign: 'bottom', height: 50})
  player.setPlay({x: 15, y: 15, delay: 500})
  player.setFullscreenOff({key: 'escape'})
  player.setFullscreenOn({align: 'right', x: 24, y: 15})

  player
