class X11 extends Remifi.Firefox.Input.Base
  Remifi.Firefox.Input.X11 = X11
  
  constructor: (@remote) ->
    Components.utils.import("resource://gre/modules/ctypes.jsm");
    
    # Open the library
    try
      # Linux
      @x11 = ctypes.open("libX11.so.6")
    catch e
      # Most other Unixes
      @x11 = ctypes.open("libX11.so")
    
    @warpPointer = @x11.declare('XWarpPointer', ctypes.default_abi, ctypes.int, ctypes.char.ptr, ctypes.int, ctypes.char.ptr, ctypes.int, ctypes.int, ctypes.unsigned_int, ctypes.unsigned_int, ctypes.int, ctypes.int)
    @openDisplay = @x11.declare('XOpenDisplay', ctypes.default_abi, ctypes.char.ptr, ctypes.int)
    @defaultRootWindow = @x11.declare('XDefaultRootWindow', ctypes.default_abi, ctypes.char.ptr, ctypes.char.ptr)
    @xflush = @x11.declare('XFlush', ctypes.default_abi, ctypes.void_t, ctypes.char.ptr)
    @xclose = @x11.declare('XCloseDisplay', ctypes.default_abi, ctypes.void_t, ctypes.char.ptr)
    
    @display = @openDisplay(0)
    @root = @defaultRootWindow(@display)
    # @xclose(display) # ever?
    
    # keysymdef.h
    @keyCodes = {
      'escape': 0xFF1B,
      'return': 0xFF0D
    }
  
  mouseClick: (x, y) =>
    @mouseOver(x, y)
    @exec '/bin/x11/mouseClick', [x, y]
    
  mouseOver: (x, y) =>
    # Display *display = XOpenDisplay(0);
    # Window root = DefaultRootWindow(display);
    # XWarpPointer(display, None, root, 0, 0, 0, 0, x, y);
    # XFlush(display);
    
    @warpPointer(@display, 0, @root, 0, 0, 0, 0, x, y)
    @xflush(@display)
    
  keyboardPress: (key) =>
    keyCode = @keyCodes[key]
    return unless keyCode
    
    @exec '/bin/x11/keyPress', [keyCode]
    
