###
//
// @import lib/std
// @import com.topdan.youtube.player
// @domain www.mydamnchannel.com
// @home.title my damn
// @home.pos  12
// @home.url  http://www.mydamnchannel.com
// @home.img  my-damn-channel.png
//
###

route '/', 'index'
route //, 'episode', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'
  action 'seriesPrev'
  action 'seriesNext'
  action 'pagingPrev'
  action 'pagingNext'

this.index = (request) ->
  title $('title')
  
  $('.slides .slide').list (r) ->
    r.title = $(this).find('span.title')
    r.url   = $(this).find('a')
    r.subtitle = $(this).find('.infoText')
  
  $('#channelNav div li').list (r) ->
    r.titleURL = $(this).find('a')
    r.image = $(this).find('img')

this.episode = (request) ->
  if request.anchor
    this.series(request)
  else
    this.show(request)

this.series = (request) ->
  title $("##{request.anchor}").parents('.seriesBrowse').find('h1')
  
  paginate [
    {name: 'prev', url: 'seriesPrev'},
    {name: 'next', url: 'seriesNext'},
  ]
  
  $("##{request.anchor} .videolist").list (r) ->
    r.title = $(this).find('h2')
    r.url   = $(this).find('a')
    r.image = $(this).find('img')
    r.subtitle = $(this).find('p')
  
  paginate [
    {name: 'prev', url: 'seriesPrev'},
    {name: 'next', url: 'seriesNext'},
  ]

this.seriesPrev = (request, index) ->
  index ||= 0
  if request.anchor
    nav = $("##{request.anchor}").parents('.seriespicker').find('.seriesNav a')
    clickOn $(nav.get(index)) if nav.length == 2
  wait ms: 1000
  
this.seriesNext = (request) ->
  seriesPrev request, 1
  
this.pagingPrev = (request) ->
  clickOn $('#paging .prev')
  wait ms: 500

this.pagingNext = (request) ->
  clickOn $('#paging .next')
  wait ms: 500

this.show = (request) ->
  title $('h1')

  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  seriesBrowse()
  previousEpisodes()

this.seriesBrowse = ->
  $('.seriesBrowse').list (r, i) ->
    id = $(this).find('.ui-carousel').attr('id')
    r.title = $(this).find('h1')
    r.url = "#{request.path}##{id}"
  
this.previousEpisodes = ->
  prevElem = $('#paging .prev')
  nextElem = $('#paging .next')
  prevUrl = 'pagingPrev' unless prevElem.length == 0 || prevElem.hasClass('hidden')
  nextUrl = 'pagingNext' unless nextElem.length == 0 || nextElem.hasClass('hidden')
  
  if $('#paging').length > 0
    paginate [
      {name: 'prev', url: prevUrl}
      {name: 'next', url: nextUrl}
    ]
    
  $('#previous_episodes_mask li').list (r) ->
    r.title = $(this).find('h2')
    r.url = $(this).find('a')
    r.image = $(this).find('img')
    r.subtitle = $(this).find('p')
  
  if $('#paging').length > 0
    paginate [
      {name: 'prev', url: prevUrl}
      {name: 'next', url: nextUrl}
    ]

this.player = () ->
  if $('.mejs-video').length > 0
    player = new Player('.mejs-video')
  
    player.setBox width: 'full', valign: 'bottom', height: 30
  
    if player.isFullscreen
      player.setPlay x: 19, y: 14, delay: 500
    else
      player.setPlay valign: 'bottom', x: 12, y: 19, delay: 500
  
    player.setFullscreenOn align: 'right', x: 12, y: 19, delay: 500

    player
  
  else
    new YouTubePlayer('#theContent iframe')