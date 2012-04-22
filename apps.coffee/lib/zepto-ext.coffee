Zepto.fn.list = (callback, options) ->
  options ||= {}
  results = []
  count = 0
  
  @each ->
    result = {}
    callback.call(this, result, count)
    results.push(result) if result.title || result.image
    count++
  
  results.sort(options.sort) if options.sort
  
  Zepto.each results, (index, item) ->
    if item.titleURL
      e = item.titleURL
      item.titleURL = null
      item.title = e
      item.url = e
    
    item.title = item.title.text()      if typeof item.title == 'object' && item.title['text']
    item.url   = item.url.attr('href')  if typeof item.url == 'object' && item.url['attr']
    item.image = item.image.attr('src') if typeof item.image == 'object' && item.image['attr']
    item.subtitle = item.subtitle.text() if typeof item.subtitle == 'object' && item.subtitle['text']
    
    item.title = null if typeof item.title == 'object'
    item.url = null if typeof item.url == 'object'
    item.image = null if typeof item.image == 'object'
    item.subtitle = null if typeof item.subtitle == 'object'
    
    item.url = externalURL(item.url) if item.url && !options.internalURL
    item.image = externalURL(item.image) if item.image
  
  list(results, options)
