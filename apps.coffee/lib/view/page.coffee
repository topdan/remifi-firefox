@pages = {type: 'pages', content: []};

ensurePage = ->
  if @pages.content.length == 0
    @pages.content.push({type: 'page', content: []});
    
    toolbar()

this.page = (id, callback) ->
  @pages.content.push({type: 'page', id: id, content: []})
  
  toolbar()
  
  callback()

this.currentPage = ->
  ensurePage()
  @pages.content[@pages.content.length - 1].content

this.fullscreen = (bool) ->
  document.isFullscreen = bool == true
  currentPage().push({type: 'fullscreen', value: document.isFullscreen})

this.toolbar = ->
  currentPage().push({type: 'toolbar'})

this.title = (name) ->
  currentPage().push({type: 'title', name: name});

this.br = ->
  currentPage().push({type: 'br'})

this.button = (name, url, options) ->
  options ||= {}
  currentPage().push({type: 'button', name: name, url: url, buttonType: options.type, disabled: options.disabled})

this.toggle = (title, url, isOn, options) ->
  options ||= {}
  currentPage().push({type: 'toggle', title: title, url: url, isOn: isOn, name: options.name})

this.error = (message) ->
  currentPage().push({type: 'error', text: message})

this.list = (items, options) ->
  options ||= {}
  currentPage().push({type: 'list', items: items, rounded: options.rounded})

this.paginate = (items) ->
  currentPage().push({type: 'paginate', items: items})