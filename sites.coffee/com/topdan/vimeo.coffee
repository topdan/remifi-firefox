###
//
// @import lib/std
// @domain vimeo.com
// @import com.topdan.vimeo.player
// @home.title vimeo
// @home.pos  9
// @home.url  http://vimeo.com
// @home.img  vimeo.png
//
###

route '/', 'index', ->
  action 'selectFeatured'
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

route /.*/, 'videoPage', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

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

this.player = () ->
  new VimeoPlayer('#featured_player,#video')
