class Hash
  Remifi.Views.Hash = Hash
  
  constructor: (@app, @request, @response) ->
    @pageCount = 0
    @view = null
    @pageTypes = new PageTypes(@)
    @formTypes = new FormTypes(@)
  
  perform: (items) =>
    items = @polishRootItems(items)
    type = items.type;

    if type == 'wait'
      @app.remote.pages.controls.wait('/', @request, @response, ms: items.ms)

    else if type == 'pages' && typeof items.content == "object" && items.content.length > 0
      p = @
      @app.remote.views (v) ->
        p.view = v
        p.performArray(items.content, p.pageTypes);

  polishRootItems: (items) =>
    type = items.type
    unless type == 'wait' || type == 'pages'
      items = [items] unless items instanceof Array
      items = {
        type: 'pages'
        content: [
          type: 'page'
          content: items
        ]
      }
    items

  performArray: (array, types) =>
    for item in array
      
      if typeof item == "object"
        type = item["type"]
        convert = types[type]
        convert(item) if typeof convert == "function"

  actionUrlFor: (action) =>
    if action == null || typeof action == 'undefined'
      null
    else if Remifi.startsWith(action, 'http://') || Remifi.startsWith(action, 'https://') || Remifi.startsWith(action, '/')
      action
    else if Remifi.startsWith(action, '#')
      '#' + @actionUrlForPage action.substring(1)
    else
      '/sites/' + @app.name + '/' + action
  
  actionUrlForPage: (page) =>
    @app.pageName ||= @app.name.replace(/[\.\/\_]/g, '-')
    "#{@app.pageName}-#{page}"
  
  class PageTypes
    
    constructor: (@p) ->
    
    page: (hash) =>
      @p.pageCount++;
      id = @p.actionUrlForPage(hash.id || @p.pageCount)
      p = @p
      @p.view.page id, ->
        p.view.toolbar()
        p.performArray(hash.content, p.pageTypes) if hash.content
  
    toolbar: (hash) =>
      @p.view.toolbar()

    title: (hash) =>
      @p.view.title(hash.name)

    toggle: (hash) =>
      url = @p.actionUrlFor(hash.url)
      @p.view.toggle(hash.title, url, hash.isOn, {name: hash.name})

    button: (hash) =>
      url = @p.actionUrlFor(hash.url)
      @p.view.button(hash.name, url, {type: hash.buttonType, disabled: hash.disabled})

    mouse: (hash) =>
      action = hash.action;
      delay = hash.delay;
      x = hash.x;
      y = Math.max(hash.y, 25);

      switch action
        when 'click'
          @p.app.remote.pages.mouse.action('click', delay, x, y);
        when 'over'
          @p.app.remote.pages.mouse.action('over', delay, x, y);

    keyboard: (hash) =>
      action = hash.action;
      key = hash.key;

      switch action
        when 'press'
          @p.app.remote.pages.keyboard.press(hash.key);

    fullscreen: (hash) =>
      @p.app.remote.currentDocument().remifiFullscreen = hash.value == true

    br: (hash) =>
      @p.view.br()

    form: (hash) =>
      return if @currentForm
      
      url = @p.actionUrlFor(hash.action)
      p = @p
      @p.view.form url, (f) ->
        p.currentForm = f;
        p.performArray(hash.content, p.formTypes) if hash.content
        p.currentForm = null;

    info: (hash) =>
      @p.view.info(hash.text)

    error: (hash) =>
      @p.view.error(hash.text)

    paginate: (hash) =>
      for item in hash.items
        item.url = @p.actionUrlFor(item.url)
      @p.view.paginate(hash.items)

    list: (hash) =>
      for item in hash.items
        item.url = @p.actionUrlFor(item.url)
      @p.view.list(hash.items, {rounded: hash.rounded, striped: hash.striped, nowrap: hash.nowrap})

    apps: (hash) =>

  class FormTypes
    
    constructor: (@p) ->
    
    fieldset: (hash) =>
      p = @p
      @p.currentForm.fieldset ->
        p.performArray(hash.content, p.formTypes) if hash.content

    br: (hash) =>
      @p.currentForm.br()

    toggle: (hash) =>
      @p.currentForm.toggle(hash.title, hash.isOn, {name: hash.name})

    url: (hash) =>
      @p.currentForm.url(hash.name, {placeholder: hash.placeholder, value: hash.value})

    search: (hash) =>
      @p.currentForm.search(hash.name, {placeholder: hash.placeholder, value: hash.value})

    submit: (hash) =>
      url = '#';
      @p.currentForm.submit(hash.name, url, {placeholder: hash.placeholder, value: hash.value})