###
//
// @import lib/std
// @domain www.reddit.com
//
###

route '/', 'subreddit'
route /^\/r\/[^\/]*\/?$/, 'subreddit'

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