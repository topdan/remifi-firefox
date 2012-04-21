###
//
// @import lib/std
// @domain movies.netflix.com
//
###

route "/WiHome", "index", ->
  action "doSearch"

route "/WiSearch", "search", ->
  action "doSearch"

route '/Queue', 'instantQueue', ->
  action "doSearch"

route /^\/WiMovie/, 'movie', ->
  action 'selectSeason'

route '/WiRoleDisplay', 'roleDisplay'

route '/Quac', 'moreLike'

this.roleDisplay = (request) ->
  title($('#page-title').text())
  
  $('.agMovie').list (r) ->
    r.image = $(this).find('.boxShotImg').attr('src')

this.index = (request) ->
  searchForm()
  
  list [
    { title: "My Instant Queue", url: "http://movies.netflix.com/Queue?qtype=ED" },
    { title: "New Arrivals", url: "http://movies.netflix.com/WiRecentAdditions" },
    { title: "Suggestions for You", url: "http://movies.netflix.com/RecommendationsHome" },
  ]

this.searchForm = () ->
  value = $('#searchField').val()
  value = "" if value == "Movies, TV shows, actors, directors, genres"
  
  form 'doSearch', (f) ->
    f.br()
    f.fieldset ->
      f.search('q', {placeholder: 'Netflix Search', value: value})

this.doSearch = (request) ->
  $('#searchField').val(request.params.q)
  $('#global-search').submit()
  wait()

this.search = (request) ->
  searchForm()
  
  $('#searchResultsPrimary .mresult').list (r) ->
    e = $(this)
    
    r.title = e.find('.mdpLink').text()
    r.url   = e.find('.mdpLink').attr('href')
    r.image = e.find('img').attr('src')
  
  paginate [
    {name: 'prev', url: $('.prev').attr('href')},
    {name: 'next', url: $('.next').attr('href')},
  ]

this.instantQueue = (request) ->
  title("Recently Watched")
  $('#athome tbody tr').list (r) ->
    e = $(this)
    
    r.title = e.find('.title a').text()
    r.url   = e.find('.title a').attr('href')
  
  title("Instant Queue")
  $('#queue tbody tr').list (r) ->
    e = $(this)
    r.title = e.find('.title a').text()
    r.url   = e.find('.title a').attr('href')

this.movie = (request) ->
  title $('h2').text()
  info $('.synopsis').text()
  
  $('#sdp-actions a,#mdp-actions a').each ->
    br()
    button($(this).find('span').text(), externalURL($(this).attr('href')))
  
  seasons(request)
  episodes(request)
  
this.seasons = (request) ->
  $('#seasons .seasonItem').list (r, i) ->
    r.title = $(this).find('a').text()
    r.active = $(this).hasClass('selected')
    r.url = 'selectSeason?num=' + i
  , internalURL: true

this.selectSeason = (request) ->
  e = $('#seasons .seasonItem').get(request.params['num'])
  clickOn $(e)
  wait ms: 500

this.episodes = (request) ->
  $('#episodeColumn li').list (r) ->
    r.title = $(this).find('.episodeTitle').text()
    r.url   = $(this).find('.btn-play').attr('data-vid') || $(this).find('.btn-play').attr('href')

this.moreLike = (request) ->
  title $('h3').text()

  button 'Move to position #1', $('.queueMoveToTop a').attr('href')
  movieSet(request)

this.movieSet = (request) ->
  $('.agMovieSet .agMovie').list (r) ->
    r.title = $(this).find('.title a').text()
    r.url   = $(this).find('.title a').attr('href')
    r.image = $(this).find('.boxShot img').attr('src')
