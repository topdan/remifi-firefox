class Mouse
  MobileRemote.Pages.Mouse = Mouse
  
  constructor: (@remote) ->
    @delay = 200;
    @program = "/bin/mouse";
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
          null,
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
      @actualMouseAction('over', null, sx, sy);

  up: (request, response) =>
    if @x && @y
      @y -= 5;
      @actualMouseAction('over', null, @x, @y);

  down: (request, response) =>
    if @x && @y
      @y += 5;
      @actualMouseAction('over', null, @x, @y);

  left: (request, response) =>
    if @x && @y
      @x -= 5;
      @actualMouseAction('over', null, @x, @y);

  right: (request, response) =>
    if @x && @y
      @x += 5;
      @actualMouseAction('over', null, @x, @y);

  click: (request, response) =>
    if @x && @y
      @actualMouseAction('click', null, @x, @y);

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

  action: (type, delay, x, y, x2, y2, up) =>
    @actualMouseAction(type, delay, x, y, x2, y2, up);

  actualMouseAction: (type, delay, x, y, x2, y2, up) =>
    args = null;

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
    
    switch type
      when 'click'
        args = ["-a", 1, "-x", x, "-y", y];
      when 'drag'
        args = ["-a", 5, "-x1", x, "-y1", y, "-x2", x2, "-y2", y2, "-up", up]
      when 'over'
        args = ["-a", 2, "-x", x, "-y", y]

    if type == 'click' && delay && delay != 0
      @actualMouseAction('over', null, x, y);
      callback = => @remote.env.exec(@program, args)
      setTimeout(callback, delay);

    else if args
      @remote.env.exec(@program, args)

    null
