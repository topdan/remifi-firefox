###
//
// @import lib/std
// @domain www.southparkstudios.com
//
###

route '/', 'index'
route '/full-episodes', 'fullEpisodes'
route /^\/full-episodes\/[^\/]+$/, 'season'

this.index = (request) ->
  title "South Park"
  
  button "Watch Full Episodes"

this.fullEpisodes = (request) ->
  button "Watch Random Episode", $('#randomep').attr('href')
  
  $('a.seasonbtn').list (r) ->
    r.url = $(this).attr('href')
    
    i = parseInt($(this).text())
    if isNaN(i)
      r.title = $(this).text()
    else
      r.title = "Season #{i}"

this.season = (request) ->
  $('.content_carouselwrap > ol > li').list (r) ->
    r.title = $(this).find('h5').text();
    r.url   = $(this).find('a').attr('href')
    r.image = $(this).find('a img').attr('src')