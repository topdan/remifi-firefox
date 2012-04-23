###
//
// @import lib/std
// @domain vimeo.com
//
###

route '/', 'index', ->
  action 'selectFeatured'
  action 'playPause'
  action 'toggleFullscreen'

route /.*/, 'videoPage', ->
  action 'playPause'
  action 'toggleFullscreen'

this.index = (request) ->
  video(request)

this.videoPage = (request) ->
  return if $('#featured_player,#video').length == 0
  
  title $('title')
  video(request)

this.featuredVideos = (request) ->
  $('#featured_videos li').list (r,i) ->
    r.title = $(this).find('.title')
    r.image = $(this).find('img')
    r.url   = 'selectFeatured?index=' + i
    r.active = $(this).attr('class') == 'selected'
    
  , internalURL: true

this.selectFeatured = (request) ->
  index = parseInt request.params['index']
  clickOn $('#featured_videos li').each (i) ->
    if index == i
      clickOn $(this).find('a')
  
  wait ms: 1000

this.video = (request) ->
  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  featuredVideos(request)

this.playPause = (request) ->
  player().play()
  video(request)

this.toggleFullscreen = (request) ->
  player().toggleFullscreen()
  video(request)

this.player = () ->
  player = new Player('#featured_player,#video')

  player.setBox({width: 'full', valign: 'bottom', height: 42})
  player.setPlay({x: 41, y: 20})
  player.setFullscreenOff({key: 'escape'})
  player.setFullscreenOn({align: 'right', x: 35, y: 18})

  player
