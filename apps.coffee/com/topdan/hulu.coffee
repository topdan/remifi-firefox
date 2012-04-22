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

route /^\/[^\/]+$/, 'tvShowOrMovie', ->
  action 'loadMoreEpisodes'

this.tvShowOrMovie = (request) ->
  if $('#episode-container').length > 0
    tvShow(request)
  else
    movie(request)

this.tvShow = (request) ->
  title($('meta[property="og:title"]').attr('content'))
  
  $('#episode-container .vsl li').list (r) ->
    e = $(this)
    title = e.find('.video-info')
    thumb = e.find('.thumbnail')
    
    r.title = e.children('a').text()
    r.url   = e.find('a').attr('href')
    r.image = thumb.attr('data-src') || thumb.attr('src')
    r.subtitle = title.text()
  
  paginate([{name: 'next', url: 'loadMoreEpisodes'}])

this.loadMoreEpisodes = (request) ->
  elem = $('#episode-container .pages li.next')
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
