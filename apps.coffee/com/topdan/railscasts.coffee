###
//
// @import lib/std
// @domain railscasts.com
//
###

route '/', 'index', ->
  action 'doSearch'

route '/episodes', 'search', ->
  action 'doSearch'

route /^\/episodes\//, 'episodeOrVideo', ->
  action 'startEpisode'
  action 'playPause'
  action 'toggleFullscreen'
  
this.index = (request) ->
  page 'index', ->
    searchForm()
    
    list [
      {title: 'Types', url: '#types'},
      {title: 'Categories', url: '#categories'}
    ]
    
    linkTo 'Remove Filter', 'http://railscasts.com' if $('.filters').length > 0
    
    episodes()
  
  page 'types', ->
    linkTo 'Cancel', '#index'
    
    types = $($('.search_option').get(0))
    types.find('li a').list (r) ->
      r.titleURL = $(this)
    
  
  page 'categories', ->
    linkTo 'Cancel', '#index'
    
    types = $($('.search_option').get(1))
    types.find('li a').list (r) ->
      r.titleURL = $(this)
      
    linkTo 'Cancel', '#index'

this.search = (request) ->
  searchForm()
  episodes()

this.episodes = (request) ->
  $('.episodes .episode').list (r) ->
    r.titleURL = $(this).find('h2 a')
    r.image = $(this).find('img')
    r.subtitle = $(this).find('.info .number').text() + " - " + $(this).find('.info .published_at').text()
  
  paginate [
   {name: 'prev', url: externalURL($('a.previous_page').attr('href'))},
   {name: 'next', url: externalURL($('a.next_page').attr('href'))}
  ]

this.episodeOrVideo = (request) ->
  if $('#video_wrapper').length
    video request
  else
    episode request

this.paginateEpisode = ->
  paginate [
    {name: 'prev', url: externalURL($('.nav .previous a').attr('href'))},
    {name: 'next', url: externalURL($('.nav .next a').attr('href'))},
  ]

this.episode = (request) ->
  paginateEpisode()
  title $('title')
  info $('.description')
  button $('.watch a').text(), 'startEpisode', type: 'primary'
  
  browseCode = $('.nav_section .browse_code a')
  if browseCode.length > 0
    br()
    linkTo 'Browse Source Code', browseCode.attr('href')

this.startEpisode = (request) ->
  clickOn $('.pretty_button')
  wait()

this.searchForm = () ->
  form 'doSearch', (f) ->
    f.br()
    f.fieldset ->
      f.search('q', {placeholder: 'Search', value: $('#search').val()})

this.doSearch = (request) ->
  $('#search').val(request.params['q']).parents('form').submit()
  wait()

this.video = (request) ->
  paginateEpisode()
  title $('title')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  button('Play/Pause', 'playPause') unless player().isFullscreen

this.player = () ->
  player = new Player('#video_wrapper')

  if player.isFullscreen
    # draggable control?
  else
    player.setBox({width: 'full', valign: 'bottom', height: 26})
    player.setPlay({x: 12, y: 12, delay: 500})

  player.setFullscreenOff({key: 'escape'})
  player.setFullscreenOn({align: 'right', x: 15, y: 15})

  player

this.playPause = (request) ->
  player().play()
  video(request)

this.toggleFullscreen = (request) ->
  player().toggleFullscreen()
  video(request)
