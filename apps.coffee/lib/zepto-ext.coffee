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
    item.url = externalURL(item.url) if item.url && !options.internalURL
    item.image = externalURL(item.image) if item.image
  
  list(results, options)
