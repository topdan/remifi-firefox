class OSX
  # https://developer.apple.com/library/mac/#documentation/Carbon/Reference/QuartzEventServicesRef/Reference/reference.html
  
  Remifi.Firefox.Input.OSX = OSX
  
  constructor: ->
    Components.utils.import("resource://gre/modules/ctypes.jsm");
    @quartzCore = ctypes.open("/System/Library/Frameworks/QuartzCore.framework/QuartzCore");
    @cgpoint = new ctypes.StructType("CGPoint", [ { "x": ctypes.double },  { "y": ctypes.double } ])
    
    @createMouseEvent = @quartzCore.declare('CGEventCreateMouseEvent', ctypes.default_abi, ctypes.char.ptr, ctypes.char.ptr, ctypes.uint32_t, @cgpoint, ctypes.uint32_t);
    @eventPost = @quartzCore.declare('CGEventPost', ctypes.default_abi, ctypes.void_t, ctypes.uint32_t, ctypes.char.ptr);
    @release = @quartzCore.declare('CFRelease', ctypes.default_abi, ctypes.void_t, ctypes.char.ptr);
    
    @createKeyboardEvent = @quartzCore.declare('CGEventCreateKeyboardEvent', ctypes.default_abi, ctypes.char.ptr, ctypes.char.ptr, ctypes.uint16_t, ctypes.bool)
    @eventSetFlags = @quartzCore.declare('CGEventSetFlags', ctypes.default_abi, ctypes.void_t, ctypes.char.ptr, ctypes.uint64_t)
    
    @mouseMoved = 5
    @mouseDown = 1
    @mouseUp = 2
    
    @leftButton = 0
    @rightButton = 1
    @centerButton = 2
    
    @keyCodes = {
      'escape': 53,
      'return': 36
    }
    
  mouseClick: (x, y) =>
    @mousePerform(@mouseMoved, @leftButton, x, y)
    @mousePerform(@mouseDown, @leftButton, x, y)
    @mousePerform(@mouseUp, @leftButton, x, y)
    
  mouseOver: (x, y) =>
    @mousePerform(@mouseMoved, @leftButton, x, y)
    
  mousePerform: (action, button, x, y) =>
    point = new @cgpoint
    point.x = x
    point.y = y
    event = @createMouseEvent(null, action, point, button)
    @eventPost(0, event)
    @release(event)

  keyboardPress: (key) =>
    code = @keyCodes[key]
    return unless code
    
    # 262144 = kCGEventFlagMaskControl
    # 2 = kCGAnnotatedSessionEventTap
    
    downEvent = @createKeyboardEvent null, code, true
    @eventSetFlags downEvent, 262144
    
    upEvent = @createKeyboardEvent null, code, false
    
    @eventPost 2, downEvent
    @eventPost 2, upEvent
    
    @release downEvent
    @release upEvent
    
    # CGEventRef downEvent = CGEventCreateKeyboardEvent(NULL, keyCode, YES);
    # CGEventSetFlags(downEvent, kCGEventFlagMaskControl);
    # 
    # CGEventRef upEvent = CGEventCreateKeyboardEvent(NULL, keyCode, NO);
    # 
    # CGEventPost(kCGAnnotatedSessionEventTap, downEvent);
    # CGEventPost(kCGAnnotatedSessionEventTap, upEvent);
    # 
    # CFRelease(downEvent);
    # CFRelease(upEvent);
    