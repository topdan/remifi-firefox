class Hash
  MobileRemote.Views.Hash = Hash
  
  constructor: (@app, @request, @response) ->
    @pageCount = 0
    @view = null
    @pageTypes = new PageTypes(@)
    @formTypes = new FormTypes(@)
  
  perform: (items) =>
    type = items.type;

    if type == 'wait'
      @app.remote.pages.controls.wait('/', @request, @response)

    else if type == 'pages' && typeof items.content == "object" && items.content.length > 0
      p = @
      @app.remote.views (v) ->
        p.view = v
        p.performArray(items.content, p.pageTypes);

  performArray: (array, types) =>
    for item in array
      
      if typeof item == "object"
        type = item["type"]
        convert = types[type]
        convert(item) if typeof convert == "function"

  actionUrlFor: (action) =>
    if action == null
      null
    else if MobileRemote.startsWith(action, 'http://') || MobileRemote.startsWith(action, 'https://') || MobileRemote.startsWith(action, '/')
      action
    else
      '/apps/' + @app.name + '/' + action
  
  class PageTypes
    
    constructor: (@p) ->
    
    page: (hash) =>
      @p.pageCount++;
      id = hash.id || "app-page-" + @p.pageCount;
      p = @p
      @p.view.page id, ->
        p.performArray(hash.content, p.pageTypes) if hash.content
  
    toolbar: (hash) =>
      @p.view.toolbar()

    title: (hash) =>
      @p.view.title(hash.name)

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
      @p.app.remote.currentDocument().mobileRemoteFullscreen = hash.value == true

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

    error: (hash) =>
      @p.view.error(hash.text)

    paginate: (hash) =>
      for item in hash.items
        item.url = @p.actionUrlFor(item.url)
      @p.view.paginate(hash.items)

    list: (hash) =>
      for item in hash.items
        item.url = @p.actionUrlFor(item.url)
      @p.view.list(hash.items, {rounded: hash.rounded})

    apps: (hash) =>

    systemApps: (hash) =>

  class FormTypes
    
    constructor: (@p) ->
    
    fieldset: (hash) =>
      p = @p
      @p.currentForm.fieldset ->
        p.performArray(hash.content, p.formTypes) if hash.content

    br: (hash) =>
      @p.currentForm.br()

    url: (hash) =>
      @p.currentForm.url(hash.name, {placeholder: hash.placeholder, value: hash.value})

    search: (hash) =>
      @p.currentForm.search(hash.name, {placeholder: hash.placeholder, value: hash.value})

    submit: (hash) =>
      url = '#';
      @p.currentForm.submit(hash.name, url, {placeholder: hash.placeholder, value: hash.value})