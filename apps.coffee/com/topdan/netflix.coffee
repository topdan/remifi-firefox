###
//
// @import lib/all
// @url    http://movies.netflix.com
//
###

route "/WiHome", "index", ->
  action "doSearch"

route "/WiSearch", "search", ->
  action "doSearch"

route '/Queue', 'instantQueue', ->
  action "doSearch"

route /^\/WiMovie/, 'movie'

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
  $('#sdp-actions a').each ->
    br()
    button($(this).find('span').text(), externalURL($(this).attr('href')))
