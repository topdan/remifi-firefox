Zepto.fn.list = (callback, options) ->
  options ||= {}
  results = []
  
  @each ->
    result = {}
    callback.call(this, result)
    results.push(result) if result.title
  
  results.sort(options.sort) if options.sort
  
  Zepto.each results, (index, item) ->
    item.url = externalURL(item.url) if item.url
    item.image = externalURL(item.image) if item.image
  
  list(results)
