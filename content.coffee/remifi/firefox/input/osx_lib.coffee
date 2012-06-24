class OSXlib
  Remifi.Firefox.Input.OSXlib = OSXlib
  
  constructor: ->
    Components.utils.import("resource://gre/modules/ctypes.jsm");
    @quartzCore = ctypes.open("/System/Library/Frameworks/QuartzCore.framework/QuartzCore");
    @cgpoint = new ctypes.StructType("CGPoint", [ { "x": ctypes.double },  { "y": ctypes.double } ])
    
    @createMouseEvent = @quartzCore.declare('CGEventCreateMouseEvent', ctypes.default_abi, ctypes.char.ptr, ctypes.char.ptr, ctypes.uint32_t, @cgpoint, ctypes.uint32_t);
    @eventPost = @quartzCore.declare('CGEventPost', ctypes.default_abi, ctypes.void_t, ctypes.uint32_t, ctypes.char.ptr);
    @release = @quartzCore.declare('CFRelease', ctypes.default_abi, ctypes.void_t, ctypes.char.ptr);
    
    @mouseMoved = 5
    @mouseDown = 1
    @mouseUp = 0
    
    @leftButton = 0
    @rightButton = 1
    @centerButton = 2
    
    @perform = (action, button, x, y) =>
      point = new @cgpoint
      point.x = x
      point.y = y
      event = @createMouseEvent(null, action, point, button)
      @eventPost(0, event)
      @release(event)
  
  mouseClick: (x, y) =>
    @perform(@mouseMoved, @leftButton, x, y)
    setTimeout ->
      @perform(@mouseDown, @leftButton, x, y)
      setTimeout ->
        @perform(@mouseUp, @leftButton, x, y)
      , 10
    , 10
    
  mouseOver: (x, y) =>
    @perform(@mouseMoved, @leftButton, x, y)
    
  mouseDown: (x, y) =>
    @perform(@mouseDown, @leftButton, x, y)
    
  mouseUp: (x, y) =>
    @perform(@mouseUp, @leftButton, x, y)
    
  keyboardPress: (key) =>
