class OSXbin
  Remifi.Firefox.Input.OSXbin = OSXbin
  
  constructor: (@remote) ->
    # foo
    
  mouseClick: (x, y) =>
    @remote.env.exec("/bin/mouse", ['-a', 1, '-x', x, '-y', y])
    
  mouseOver: (x, y) =>
    @remote.env.exec("/bin/mouse", ['-a', 2, '-x', x, '-y', y])
    
  mouseDown: (x, y) =>
    @remote.env.exec("/bin/mouse", ['-a', 3, '-x', x, '-y', y])
    
  mouseUp: (x, y) =>
    @remote.env.exec("/bin/mouse", ['-a', 4, '-x', x, '-y', y])
    
  keyboardPress: (key) =>
    