###
//
// @import lib/std
// @import com.topdan.youtube.player
// @domain www.khanacademy.org
// @home.title khan acad
// @home.pos  10
// @home.url  http://www.khanacademy.org
// @home.img  khan-academy.png
//
###

route '/', 'index'

route "/", "index", ->
  action 'playPause', on: 'player'
  action 'startOver', on: 'player'
  action 'toggleFullscreen', on: 'player'

route /.*/, 'video', ->
  action 'playPause', on: 'player'
  action 'startOver', on: 'player'
  action 'toggleFullscreen', on: 'player'

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
      linkTo 'Topics', '#topics'
      
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
    r.imageWidth = 160
    r.imageHeight = 120
    
this.category = (request) ->
  anchor = request.anchor
  plus = anchor.indexOf('+')
  anchor = anchor.substring(0, plus) if plus
  
  category = $("##{anchor}-container")

  linkTo 'Back to Home', externalURL('/#')
  title category.find('h2')

  category.find('li').list (r) ->
    r.title = $(this)
    r.url   = $(this).find('a')

this.video = (request) ->
  title $('span.title')
  info $('.long-description').text().substring(2) if $('.long-description').length > 0
  
  player().controls()
  
  linkTo $('.previous-video span'), $('.previous-video').attr('href')
  linkTo $('.next-video span'), $('.next-video').attr('href')

this.player = () ->
  new YouTubePlayer('#main-video-link,.youtube-video')

