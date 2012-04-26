###
//
// @import lib/std
// @domain grooveshark.com
//
###

beforeFilter 'readHashbang'

route '/', 'index', ->
  action 'doSearch'
  
route '/', 'search', anchor: /^!\/search/, ->
  action 'doSearch'

this.index = (request) ->
  title 'hi'

this.search = (request) ->
  searchForm()
  
  title 'Albums'
  $('#albumDigest li').list (r) ->
    r.title = $(this).find('.meta .name')
    r.url = $(this).find('.meta a')
    r.subtitle = $(this).find('.by')
    r.image = $(this).find('img')
  
  title 'Songs'
  $('#songDigest .slick-row').list (r) ->
    r.titleURL = $(this).find('.songName')
    r.subtitle = $(this).find('.artist')

this.searchForm = ->
  form 'doSearch', (f) ->
    f.br()
    f.fieldset ->
      f.search('q', {placeholder: 'Grooveshark Search', value: $('#header_search input').val() || @hashbang.params['q']})

this.doSearch = (request) ->
  document.location.href = externalURL("/#!/search?q=#{request.params.q}")
  wait ms: 1000

this.readHashbang = (request) ->
  if request.anchor && request.anchor.match(/^!/)
    this.hashbang = new URI(request.anchor.substring(1))