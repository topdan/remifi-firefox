Zepto.fn.list = (callback, options) ->
  options ||= {}
  
  paginateItems = null
  page = null
  perPage = options.perPage || 50
  
  if @length > perPage
    if request.anchor
      position = request.anchor.indexOf('+remotePage')
      unless position == -1
        pagelessAnchor = request.anchor.substring(0, position)
        page = parseInt(request.anchor.substring(position + '+remotePage'.length))
    
    page ||= 1
    pagelessAnchor ||= request.anchor unless typeof pagelessAnchor == 'string'
    maxItem = page * perPage
    minItem = maxItem - perPage
    maxPage = Math.ceil(@length / perPage)
    
    if page > 1
      prevUrl = externalURL("##{pagelessAnchor}+remotePage#{page-1}")
    else
      prevUrl = null
    
    if page < maxPage
      nextUrl = externalURL("##{pagelessAnchor}+remotePage#{page+1}")
    else
      nextUrl = null
    
    paginateItems = [{name: 'prev', url: prevUrl}, {name: 'next', url: nextUrl}]
  
  results = []
  count = 0
  
  @each ->
    if page == null || (count >= minItem && count < maxItem)
      result = {}
      callback.call(this, result, count)
      
      if result.title || result.image || result.titleURL
        results.push(result)
        count++
  
  results.sort(options.sort) if options.sort
  
  Zepto.each results, (index, item) ->
    if item.titleURL
      item.title = item.titleURL
      item.url = item.titleURL
      item.titleURL = null
    
    item.title = item.title.text()       if item.title != null && typeof item.title == 'object' && item.title['text']
    item.url   = item.url.attr('href')   if item.title != null && typeof item.url == 'object' && item.url['attr']
    item.subtitle = item.subtitle.text() if item.title != null && typeof item.subtitle == 'object' && item.subtitle['text']
    
    if typeof item.image == 'object' && item.image['attr']
      item.imageWidth ||= item.image.attr('width')
      item.imageHeight ||= item.image.attr('height')
      item.image = item.image.attr('src')
    
    item.title = null    if typeof item.title == 'object'
    item.url = null      if typeof item.url == 'object'
    item.image = null    if typeof item.image == 'object'
    item.subtitle = null if typeof item.subtitle == 'object'
    
    item.url = externalURL(item.url) if item.url && !options.internalURL
    item.image = externalURL(item.image) if item.image && !options.imageInternalURL
  
  paginate paginateItems if paginateItems
  list results, options
  paginate paginateItems if paginateItems
