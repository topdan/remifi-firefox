@pages = {type: 'pages', content: []};

ensurePage = ->
  if @pages.content.length == 0
    @pages.content.push({type: 'page', content: []});
    
    toolbar()

@page = (id, callback) ->
  @pages.content.push({type: 'page', id: id, content: []})
  
  toolbar()
  
  callback()

@currentPage = ->
  ensurePage()
  @pages.content[@pages.content.length - 1].content

@fullscreen = (bool) ->
  document.isFullscreen = bool == true
  currentPage().push({type: 'fullscreen', value: document.isFullscreen})

@toolbar = ->
  currentPage().push({type: 'toolbar'})

@title = (name) ->
  currentPage().push({type: 'title', name: name});

@br = ->
  currentPage().push({type: 'br'})

@button = (name, url, options) ->
  options ||= {}
  currentPage().push({type: 'button', name: name, url: url, buttonType: options.type, disabled: options.disabled})

@error = (message) ->
  currentPage().push({type: 'error', text: message})

@list = (items, options) ->
  options ||= {}
  currentPage().push({type: 'list', items: items, rounded: options.rounded})

@paginate = (items) ->
  currentPage().push({type: 'paginate', items: items})
