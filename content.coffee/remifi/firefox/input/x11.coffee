class X11
  Remifi.Firefox.Input.X11 = X11
  
  constructor: ->
    Components.utils.import("resource://gre/modules/ctypes.jsm");
    
    # Open the library
    try
      # Linux
      @x11 = ctypes.open("libX11.so.6")
    catch e
      # Most other Unixes
      @x11 = ctypes.open("libX11.so")
    
    # int XWarpPointer(Display *display, Window src_w, Window dest_w, int src_x, int src_y, unsigned int src_width, unsigned int src_height, int dest_x, int dest_y); 
    
    @warpPointer = @x11.declare('XWrapPointer', ctypes.default_abi, ctypes.int, ctypes.char.ptr, ctypes.char.ptr, ctypes.int, ctypes.int, ctypes.unsigned_int, ctypes.unsigned_int, ctypes.int, ctypes.int)
    @openDisplay = @x11.declare('XOpenDisplay', ctypes.default_abi, ctypes.char.ptr, ctypes.int)
    @defaultRootWindow = @x11.declare('DefaultRootWindow', ctypes.default_abi, ctypes.char.ptr, ctypes.char.ptr)
    
  mouseClick: (x, y) =>
    @mousePerform(@mouseMoved, @leftButton, x, y)
    @mousePerform(@mouseDown, @leftButton, x, y)
    @mousePerform(@mouseUp, @leftButton, x, y)
    
  mouseOver: (x, y) =>
    # Display *display = XOpenDisplay(0);
    # Window root = DefaultRootWindow(display);
    # XWarpPointer(display, None, root, 0, 0, 0, 0, x, y);
    
    display = @openDisplay(0)
    root = defaultRootWindow(display)
    
    @warpPointer(display, null, root, 0, 0, 0, 0, x, y)
