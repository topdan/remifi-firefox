###
//
// @import lib/std
// @domain www.hulu.com
// @home.title hulu
// @home.pos  5
// @home.url  http://www.hulu.com
// @home.img  hulu.png
//
###

@badge = 'http://static.huluim.com/images/icon-hulu-plus-badge-light.gif'

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
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  action 'loadMoreEpisodes'

route /^\/[^\/]+$/, 'tvShowOrMovie', ->
  action 'loadMoreEpisodes'
  action 'expandSeason'

this.tvShowOrMovie = (request) ->
  if $('#full-episode-container,#episode-container').length > 0
    tvShow(request)
  else
    movie(request)

this.tvShow = (request) ->
  if request.anchor == 'show-expander'
    tvShowEpisodes(request)
    return
  
  title($('meta[property="og:title"]').attr('content'))
  
  linkTo 'All episodes', externalURL('#show-expander')
  
  if $('#full-episode-container').length > 0
    baseId = '#full-episode-container'
  else
    baseId = '#episode-container'
  
  self = this
  $("#{baseId} .vsl li").list (r) ->
    e = $(this)
    title = e.find('.video-info')
    thumb = e.find('.thumbnail')
    
    r.title = e.children('a.beaconid').text()
    r.url   = e.find('a').attr('href')
    r.image = thumb.attr('data-src') || thumb.attr('src')
    r.subtitle = title.text()
    r.badge = self.badge if e.children('a').length == 2
    r.active = e.find('.currently-playing').attr('style') != 'display: none'
  
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

this.tvShowEpisodes = (request) ->
  self = this
  
  page 'index', ->
    $('#show-expander .srh').list (r,i) ->
      r.title = $(this).find('td.vex-down,td.vex-up').text()
      
      nextRow = $(this).next('tr')
      if nextRow.length > 0 && !nextRow.hasClass('srh')
        r.url = "#season-#{i}"
      else
        r.url = "expandSeason?i=#{i}"
      
      r.badge = self.badge if $(this).find('.plus-season').length > 0
      
    , internalURL: true
  
  $('#show-expander .srh').each (i) ->
    seasonRow = $(this)
    
    page "season-#{i}", ->
      linkTo 'back', '#index'
      
      episodes = []
      row = seasonRow.next('tr')
      while row.length > 0 && !row.hasClass('srh')
        a = row.find('.c1 a.info_hover')
        episode = {}
        
        episode.title = a.text()
        episode.url   = a.attr('href')
        episode.badge = self.badge if row.find('.vex-h-sticker').length > 0
        
        episodes.push episode if episode.title && episode.url
        row = row.next('tr')
      
      list episodes
      linkTo 'back', '#index'

this.expandSeason = (request) ->
  i = request.params.i
  return unless i
  
  i = parseInt i
  e = $('#show-expander .srh').get(i)
  
  clickOn $(e).find('td')
  wait ms: 1000

this.movie = (request) ->

this.prevPage = (request) ->
  elem = $($('.page li').get(2)).find('a')
  clickOn(elem) if elem.length > 0
  wait ms: 500

this.nextPage = (request) ->
  elem = $($('.page li').get(6)).find('a')
  clickOn(elem) if elem.length > 0
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
    
    if r.title == null && e.find('.playlist-bar').length > 0
      home = e.find('.home-thumb')
      div = home.children('div').get(1)
      if div
        div = $(div)
        r.title = div.text()
        r.url = div.find('a')
        r.subtitle = "Playlist"
    
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

this.player = () ->
  player = new Player('#player')

  player.setBox({width: 'full', valign: 'bottom', height: 50})
  player.setPlay({x: 15, y: 15, delay: 500})
  player.setFullscreenOn({align: 'right', x: 24, y: 15})

  player
