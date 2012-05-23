###
//
// @import lib/std
// @domain www.reddit.com
// @home.title reddit
// @home.pos  4
// @home.url  http://www.reddit.com
// @home.img  reddit.png
//
###

route '/', 'index'
route /^\/r\/[^\/]*\/?$/, 'subreddit'

this.index = (request) ->
  page 'index', ->
    list [
      {title: 'My Reddits', url: '#my-reddits'},
      {title: "r/NetflixBestOf", url: "http://www.reddit.com/r/NetflixBestOf/"},
      {title: "r/music", url: "http://www.reddit.com/r/music/"}
    ]
    
    subreddit(request)
    
  page 'my-reddits', ->
    title "My Reddits"

    button 'Cancel', '#index'
    $('#sr-bar li a').list (r) ->
      r.titleURL = $(this)
    button 'Cancel', '#index'

this.subreddit = (request) ->
  if (request.path == '/')
    title('reddit - front page')
  else
    title('reddit - ' + $('title').text())
  
  $('#siteTable .thing').list (r) ->
    r.title = $(this).find('a.title').text()
    r.url   = $(this).find('a.title').attr('href')
    r.image = $(this).find('.thumbnail img').attr('src')
    r.subtitle = $(this).find('.domain a').text()
  , striped: true
  
  prev = null
  next = null
  $('.nextprev a').each ->
    rel = $(this).attr('rel')
    if rel == 'nofollow prev'
      prev = $(this).attr('href')
    else if rel == 'nofollow next'
      next = $(this).attr('href')
  
  paginate [
    {name: 'prev', url: prev },
    {name: 'next', url: next }
  ]