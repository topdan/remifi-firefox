class Mouse
  Remifi.Pages.Mouse = Mouse
  
  constructor: (@remote) ->
    @delay = 200;
    
    if @remote.env.isWindows
      @program = "/bin/mouse.exe"
    else
      @program = "/bin/mouse"
    
    @x = null;
    @y = null;

  render: (request, response) =>
    if request.path == '/mouse/index.html' || request.path == '/mouse/'
      @index(request, response);
      
    else if request.path == '/mouse/over.js'
      @over(request, response);
      
    else if request.path == '/mouse/up.js'
      @up(request, response);
      
    else if request.path == '/mouse/down.js'
      @down(request, response);
      
    else if request.path == '/mouse/left.js'
      @left(request, response);
      
    else if request.path == '/mouse/right.js'
      @right(request, response);
      
    else if request.path == '/mouse/click.js'
      @click(request, response);
      
    else if request.path == '/mouse/hide.js'
      @hide(request, response);
      
    else if request.path == '/mouse/page-up.js'
      @pageUp(request, response);
      
    else if request.path == '/mouse/page-down.js'
      @pageDown(request, response);
  
  index: (request, response) =>
    @remote.views (v) ->
      v.page 'mouse', ->
        v.toolbar();

        width = 310;
        height = 232;

        v.template('/views/mouse.html', {width: width, height: height});

        v.apps([
          {title: 'keyboard', url: '/keyboard/', icon: {url: '/static/images/keyboard.png'}},
          {title: 'hide', url: '/mouse/hide.js', icon: {url: '/static/images/mouse.png'}},
          {title: 'page up', url: '/mouse/page-up.js', icon: {url: '/static/images/pageup.png'}},
          {title: 'page down', url: '/mouse/page-down.js', icon: {url: '/static/images/pagedown.png'}},
        ]);

  over: (request, response) =>
    x = parseFloat(request.params["x"]);
    y = parseFloat(request.params["y"]);

    unless isNaN(x) || isNaN(y)
      sx = screen.width;
      sy = screen.height;

      sx = Math.floor(sx * x);
      sy = Math.floor(sy * y);
      @actualMouseAction('over', sx, sy);

  up: (request, response) =>
    if @x && @y
      @y -= 5;
      @actualMouseAction('over', @x, @y);

  down: (request, response) =>
    if @x && @y
      @y += 5;
      @actualMouseAction('over', @x, @y);

  left: (request, response) =>
    if @x && @y
      @x -= 5;
      @actualMouseAction('over', @x, @y);

  right: (request, response) =>
    if @x && @y
      @x += 5;
      @actualMouseAction('over', @x, @y);

  click: (request, response) =>
    if @x && @y
      @actualMouseAction('click', @x, @y);

  hide: (request, response) =>
    @actualMouseAction('over', screen.width - 1, screen.height - 100)

  pageUp: (request, response) =>
    s = Components.utils.Sandbox(content);
    s.window = @remote.currentBrowser().contentWindow;
    s.document = @remote.currentBrowser().contentDocument;

    Components.utils.evalInSandbox("window.scrollTo(0, Math.max(0, window.scrollY - window.innerHeight/2));", s);

  pageDown: (request, response) =>
    s = Components.utils.Sandbox(content);
    s.window = @remote.currentBrowser().contentWindow;
    s.document = @remote.currentBrowser().contentDocument;

    Components.utils.evalInSandbox("window.scrollTo(0, window.scrollY + window.innerHeight/2);", s);

  action: (type, x, y, options) =>
    @actualMouseAction(type, x, y, options)

  programArgs: (type, x, y) =>
    switch type
      when 'click'
        if @remote.env.isWindows
          [1, x, y]
        else
          ["-a", 1, "-x", x, "-y", y]
      when 'over'
        if @remote.env.isWindows
          [2, x, y]
        else
          ["-a", 2, "-x", x, "-y", y]

  actualMouseAction: (type, x, y, options) =>
    options ||= {}
    delay = options.delay
    hide = options.hide

    if x >= screen.width
      x = screen.width - 1;
    else if x < 0
      x = 0;

    if y >= screen.height
      y = screen.height - 1;
    else if y < 0
      y = 0;

    @x = x
    @y = y
    args = @programArgs(type, @x, @y)

    if hide
      exec = =>
        @remote.env.exec(@program, args)
        setTimeout =>
          @hide()
        , 100
    else
      exec = => @remote.env.exec(@program, args)

    if type == 'click' && delay && delay != 0
      @actualMouseAction('over', x, y)
      setTimeout(exec, delay)

    else if args
      exec()

    null
