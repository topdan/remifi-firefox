class this.Player
  
  constructor: (@selector) ->
    @mouse = new Mouse()
    @keyboard = new Keyboard()
    @isFullscreen = document.isFullscreen == true
    @actions = {}
    @buttons = {}
    @lines = {}
    
    if @isFullscreen
      @left = 0
      @top = 0
      @width = screen.width - 1
      @height = screen.height - 1

    else
      elem = $(selector)
      
      if elem.length == 0
        @error = true
        throw 'element not found: ' + selector
        return
      
      # window.scrollTo(elem);
      
      elemOffset = elem.offset()
      elemHeight = elem.height()
      elemWidth  = elem.width()
      
      # TODO remove the hardcoded height of the toolbars
      @top = window.browserY + elemOffset.top
      @left = window.browserX + elemOffset.left
      @height = elemHeight
      @width = elemWidth
    
    @bottom = @top + @height
    @right = @left + @width
    
    @box = { top: @top, left: @left, right: @right, bottom: @bottom, width: @width, height: @height }
  
  play: =>
    @clickButton('play')
  
  fullscreenOn: =>
    @clickButton('fullscreen-on')
  
  fullscreenOff: =>
    @clickButton('fullscreen-off')
  
  seek: (num) =>
    @clickLine('seek', num)
  
  toggleFullscreen: =>
    if @isFullscreen
      @fullscreenOff();
    else
      @fullscreenOn()
  
  clickLine: (name, t) =>
    line = @lines[name]
    throw "no line named " + name if line == null
    
    if line.x
      x = line.x
      y = @mouse.line(t, line.y1, line.y2);
      
    else
      x = @mouse.line(t, line.x1, line.x2)
      y = line.y;
    
    @mouse.click(x, y, line.delay)
  
  clickButton: (name) =>
    button = @buttons[name]
    throw "no button named " + name if button == null
    
    if button.key
      @keyboard.press(button.key)
    else
      @mouse.click(button.x - window.scrollX, button.y - window.scrollY, button.delay)
    
    button.callback() if button.callback
  
  overButton: (name) =>
    button = @buttons[name]
    throw "no button named " + name if button == null
    @mouse.over(button.x, button.y)
  
  #
  # Setting up the player
  #
  
  setPlay: (options) =>
    @addButton('play', options)
  
  setFullscreenOff: (options) =>
    options.callback = -> fullscreen(false)
    @addButton('fullscreen-off', options)
  
  setFullscreenOn: (options) =>
    options.callback = -> fullscreen(true)
    @addButton('fullscreen-on', options)
  
  setSeek: (options) =>
    @addLine('seek', options)
  
  setBox: (options) =>
    @box = {}
    
    switch options.width
      when 'full'
        @box.width = @width
      else
        @box.width = options.width
    
    switch options.align
      when 'middle'
        @box.left = @left + @width/2 - @box.width/2
        
      else
        @box.left = @left

    @box.height = options.height
    @box.top = @top + @height - @box.height
    
    @box.bottom = @box.top + @box.height
    @box.right = @box.left + @box.width
  
  addButton: (name, options) =>
    button = {delay: options.delay, callback: options.callback}
    
    if options.key
      button.key = options.key;
    else
      button.x = @alignX(options.align, options.x)
      button.y = @alignY(options.valign, options.y)
    
    @buttons[name] = button
    @actions[name] = -> @clickButton(name)
  
  addLine: (name, options) =>
    line = {delay: options.delay}
    
    line.x  = @alignX(options.align, options.x)  if typeof options.x  == "number"
    line.x1 = @alignX(options.align, options.x1) if typeof options.x1 == "number"
    line.x2 = @alignX(options.align, options.x2) if typeof options.x2 == "number"
    
    line.y  = @alignY(options.valign, options.y)  if typeof options.y  == "number"
    line.y1 = @alignY(options.valign, options.y1) if typeof options.y1 == "number"
    line.y2 = @alignY(options.valign, options.y2) if typeof options.y2 == "number"
    
    @lines[name] = line
  
  alignX: (align, x) =>
    switch align
      when 'right'
        @box.right - x
        
      when 'middle'
        @box.left + @box.width / 2;
        
      else
        @box.left + x
  
  alignY: (align, y) =>
    switch align
      when 'bottom'
        @box.bottom - y
        
      else
        @box.top + y
