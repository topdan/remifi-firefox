# ###
# //
# // @import lib/std
# // @domain www.5secondfilms.com
# // @domain 5secondfilms.com
# // @home.title 5 second
# // @home.pos  13
# // @home.url  http://www.5secondfilms.com
# // @home.img  ted.png
# //
# ###
# 
# route '/', 'indexOrFilm', ->
#   action 'playPause', on: 'player'
#   action 'toggleFullscreen', on: 'player'
#   action 'nextVideo'
#   action 'prevVideo'
# 
# route /\/watch\/[^\/]+/, 'indexOrFilm', ->
#   action 'playPause', on: 'player'
#   action 'toggleFullscreen', on: 'player'
#   action 'nextVideo'
#   action 'prevVideo'
# 
# 
# this.indexOrFilm = (request) ->
#   if $('#nextFilmArrow').length > 0
#     @index(request)
#   else
#     @film(request)
# 
# this.index = (request) -> 
#   button 'Play/Pause', 'playPause'
#   toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
#   
#   paginate [
#    {name: 'prev', url: 'prevVideo'},
#    {name: 'next', url: 'nextVideo'}
#   ]
# 
# this.nextVideo = ->
#   clickOn $('#nextFilmArrow'), actual: true
# 
# this.prevVideo = ->
#   clickOn $('#prevFilmArrow'), actual: true
# 
# this.player = () ->
#   player = new Player('#entry-content')
#   
#   player.setPlay x: 15, y: 15, valign: 'bottom'
#   player.setFullscreenOn align: 'right', x: 25, y: 25, delay: 500
#   
#   player