###
//
// @import lib/std
// @domain www.showtimeanytime.com
// @home.title showtime
// @home.pos  7
// @home.url  http://www.showtimeanytime.com
// @home.img  showtime.png
//
###

route "/", "index"

this.index = (request) ->
  title 'Showtime'

  list [
    { title: "Series", url: externalURL("/#/series/allseries") },
    { title: "Movies", url: externalURL("/#/movies/allmovies") },
    { title: 'After Hours', url: externalURL('/#/afterhours/allafterhours') }
  ]
