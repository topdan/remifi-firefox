###
//
// @import lib/std
// @import com.topdan.youtube.player
// @domain www.khanacademy.org
//
###

route '/', 'index'

route "/", "index", ->
  action 'playPause'
  action 'startOver'
  action 'toggleFullscreen'

route /.*/, 'video', ->
  action 'playPause'
  action 'startOver'
  action 'toggleFullscreen'

this.dashize = (string) ->
  string.toLowerCase().
    replace(/^[\ ]+/g, '').
    replace(/[\ ]+$/g, '').
    replace(/\./g, '').
    replace(/[\_\ &]/g, '-').
    replace(/[\-]+/g, '-')

this.index = (request) ->
  if request.anchor && request.anchor.length > 0
    category request
    return
  
  # zepto didn't like the > ul > li syntax
  topics = $('#page_main_nav').children('ul').children('li')
  
  page 'index', =>
    title $('title')
    
    topics.list (r) ->
      return if $(this).hasClass('solo')
      
      b = $(this).text()
      a = $(this).find('ul').text() || ""
      
      r.title = b.substring(0, b.length - a.length)
      r.url = "##{dashize(r.title)}"
    , internalURL: true
    
    this.thumbnails()
    
  topics.each ->
    b = $(this).text()
    a = $(this).find('ul').text() || ""
    name = b.substring(0, b.length - a.length)
    
    page dashize(name), =>
      button 'Topics', '#topics'
      
      $(this).find('li').list (r) ->
        r.title = $(this).text()
        r.url = $(this).find('a')

this.thumbnails = ->
  $('#thumbnails td').list (r) ->
    r.title = $(this).find('.thumbnail_desc')
    r.url   = $(this).find('a')
    
    style = $(this).find('.thumb').attr('style')
    r.image = style.match(/\'([^\']+)\'/)[1] if style && style['match']
    r.image ||= $(this).find('.thumb').attr('data-src')
    
this.category = (request) ->
  category = $("##{request.anchor}-container")

  button 'Back to Home', externalURL('/#')
  title category.find('h2')

  category.find('li').list (r) ->
    r.title = $(this)
    r.url   = $(this).find('a')

this.video = (request) ->
  title $('span.title')
  info $('.long-description').text().substring(2)
  
  player().controls()
  
  button $('.previous-video span'), $('.previous-video').attr('href')
  button $('.next-video span'), $('.next-video').attr('href')

this.player = () ->
  new YouTubePlayer('#main-video-link,.youtube-video')

this.playPause = (request) ->
  player().play()
  video(request)

this.startOver = (request) ->
  player().seek(0)
  video(request)

this.toggleFullscreen = (request) ->
  player().toggleFullscreen()
  video(request)

