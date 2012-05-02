class Base
  MobileRemote.Views.Base = Base
  
  constructor: (@env) ->
    @out = []
  
  html: () =>
    @out.join("")

  safeOut: (s) =>
    @out.push(s)

  template: (path, data) =>
    data ||= {}
    data.escape = @escape;
    data.escapeHTML = @escapeHTML;

    code = @env.fileContent(path);
    throw "viewpath not found: " + path if code == null

    func = MobileRemote.microtemplate(code);
    html = func(data);

    @out.push(html);

    html

  escape: (string) =>
    MobileRemote.escape(string)

  escapeHTML: (string) =>
    MobileRemote.escapeHTML(string)

  externalURL: (url) =>
    MobileRemote.externalURL(url)

  page: (id, callback) =>
    @out.push('<div id="' + id + '">');
    callback();
    @out.push('</div>')

  toolbar: (options) =>
    options ||= {}
    right = options.right || {title: 'home', url: '/home.html'};
    @template('/views/toolbar.html', {back: options.back, stop: options.stop, right: right})

  title: (title) =>
    @out.push('<h1>' + @escapeHTML(title) + '</h1>')

  button: (name, url, options) =>
    options ||= {}
    
    klass = null;
    if options.type == "info"
      klass = "grayButton"
    else if options.type == "danger"
      klass = "redButton";
    else if options.type == "primary"
      klass = "greenButton";
    else
      klass = "whiteButton"

    rest = 'class="' + @escape(klass) + '"'
    if typeof options.disabled == "string"
      rest += ' href="#" data-disabled-message="' + options.disabled + '"'
    else if options.openLocally
      rest += ' target="_blank" href="' + @escape(url) + '"'
    else if @externalURL(url)
      rest += ' href="#" data-remote-url="' + @escape(url) + '"'
    else
      rest += ' href="' + @escape(url) + '"'

    @out.push('<a ' + rest + '>' + @escapeHTML(name) + '</a>')

  br: () =>
    @out.push("<br/>")

  form: (url, callback) =>
    form = new MobileRemote.Views.Form(@, @env, url);
    callback(form);
    @out.push(form.html())

  error: (message) =>
    @out.push('<p class="error-message">', @escapeHTML(message), '</p>')

  info: (message) =>
    @out.push('<p class="info-message">', @escapeHTML(message), '</p>')

  toggle: (title, url, isOn, options) =>
    options ||= {}
    options.standAlone = true
    
    @form url, (f) ->
      f.fieldset ->
        f.toggle title, isOn, options

  paginate: (items) =>
    polished = [];
    for item in items
      if item.name && item.url
        name = item.name;
        if item.name == "prev"
          if items.length < 3
            name = "&laquo; Previous"
          else
            name = "&laquo;"
        
        else if item.name == "next"
          if items.length < 3
            name = "Next &raquo;"
          else
            name = "&raquo;"
        
        else
          name = @escape(name);

        if @externalURL(item.url)
          url = "#";
          remoteURL = item.url;
        else
          url = item.url;
          remoteURL = null;

        polished.push({name: name, url: url, remoteURL: remoteURL});

    @template('/views/paginate.html', {items: polished});

  list: (items, options) =>
    options ||= {}
    return if items == null || items.length == 0
    
    @template("/views/list.html", {items: items, rounded: options.rounded, striped: options.striped, nowrap: options.nowrap})

  apps: (apps, options) =>
    options ||= {}
    return if apps.length == 0
    
    row = []
    rows = [row];
    count = 0;
    for app in apps
      if count == 4
        row = []
        rows.push(row)
        count = 0

      if app == null
        app = {isBlank: true, icon: {}};

      else if app.icon == null
        app.icon = {
          width: 60,
          height: 60,
          url: '/static/images/bhg.png'
        }
      else if app.icon == 'folder'
        app.icon = {
          width: 60,
          height: 60,
          url: '/static/images/crystal_clear_icons/folder_grey_open.png'
        }

      row.push(app)
      count++

    row.push({isBlank: true}) while (row.length < 4)

    @template("/views/buttons.html", {rows: rows, tableId: options.tableId, tableClass: options.tableClass});
