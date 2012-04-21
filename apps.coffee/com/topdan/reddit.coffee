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
  , wrap: true