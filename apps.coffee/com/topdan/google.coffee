###
//
// @import lib/all
// @url    http://www.google.com
//
###

route '/', 'index', ->
  action 'doSearch'

route '/search', 'search'

@index = ->
  br()
  br()
  
  form 'doSearch', (f) ->
    f.fieldset ->
      f.search 'q', {placeholder: 'Google Search'}
    
    f.br()
    f.br()
    
    f.submit('Google Search')

@doSearch = (request) ->
  document.location.href = 'http://www.google.com/search?q=' + encodeURIComponent(request.params.q) + '&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a'
  wait()

@search = ->
  title($('title').text())
  
  $('#rso h3 a').list (r) ->
    r.title = $(this).text()
    r.url = $(this).attr('href')
  
  paginate([
    {name: 'prev', url: externalURL($('#pnprev').attr('href'))},
    {name: 'next', url: externalURL($('#pnnext').attr('href'))}
  ])
