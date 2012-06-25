class Win32
  Remifi.Firefox.Input.Win32 = Win32
  
  constructor: ->
    @keyCodes = {
      'escape': 0x1B,
      'return': 0x0D
    }
    
    Components.utils.import("resource://gre/modules/ctypes.jsm");
    @user32 = ctypes.open("user32.dll")
    
    dword = ctypes.uint32_t;
    word = ctypes.uint16_t;
    
    @mouseInput = new ctypes.StructType("MOUSEINPUT", [
      { "dx": ctypes.long },
      { "dy": ctypes.long },
      { "mouseData": dword },
      { "dwFlags": dword },
      { "time": dword },
      { "dwExtraInfo": ctypes.char.ptr }
    ])
    
    @mouseEvent = new ctypes.StructType("mouseEvent", [ 
      { "type": dword },  
      { "mi": @mouseInput }
    ])
    
    @keyboardInput = new ctypes.StructType("KEYBOARDINPUT", [
      { "wVk": word },
      { "wScan": word },
      { "dwFlags": dword },
      { "time": dword },
      { "dwExtraInfo": ctypes.char.ptr }
    ])
    
    @keyboardEvent = new ctypes.StructType("keyboardEvent", [ 
      { "type": dword },  
      { "ki": @keyboardInput }
    ])
    
    @sendInput = @user32.declare('SendInput', ctypes.winapi_abi, ctypes.unsigned_int, ctypes.unsigned_int, ctypes.voidptr_t, ctypes.int)
  
  mouseClick: (x, y) =>
    @mouseOver(x, y)
    @leftMouseClick()
    
  mouseOver: (x, y) =>
    # double fScreenWidth    = ::GetSystemMetrics( SM_CXSCREEN )-1; 
    # double fScreenHeight  = ::GetSystemMetrics( SM_CYSCREEN )-1; 
    # double fx = x*(65535.0f/fScreenWidth);
    # double fy = y*(65535.0f/fScreenHeight);
    # INPUT  Input={0};
    # Input.type      = INPUT_MOUSE;
    # Input.mi.dwFlags  = MOUSEEVENTF_MOVE|MOUSEEVENTF_ABSOLUTE;
    # Input.mi.dx = fx;
    # Input.mi.dy = fy;
    # ::SendInput(1,&Input,sizeof(INPUT));
    
    fScreenWidth = screen.width - 1
    fScreenHeight = screen.height - 1
    
    fx = x*(65535.0/fScreenWidth)
    fy = y*(65535.0/fScreenHeight)
    
    input = new @mouseEvent
    input.type = 0 # INPUT_MOUSE
    input.mi.dwFlags = 0x0001 | 0x8000 # MOUSEEVENTF_MOVE|MOUSEEVENTF_ABSOLUTE
    input.mi.dx = Math.round(fx)
    input.mi.dy = Math.round(fy)
    
    @sendInput 1, input.address(), 28 # sizeof(INPUT)
    
  leftMouseDown: =>
    # INPUT    Input={0};
    # // left down 
    # Input.type      = INPUT_MOUSE;
    # Input.mi.dwFlags  = MOUSEEVENTF_LEFTDOWN;
    # ::SendInput(1,&Input,sizeof(INPUT));
    
    input = new @mouseEvent
    input.type = 0
    input.mi.dwFlags = 2
    
    @sendInput 1, input.address(), 28
    
  leftMouseUp: =>
    # INPUT    Input={0};
    # Input.type      = INPUT_MOUSE;
    # Input.mi.dwFlags  = MOUSEEVENTF_LEFTUP;
    # ::SendInput(1,&Input,sizeof(INPUT));
    
    input = new @mouseEvent
    input.type = 0
    input.mi.dwFlags = 4
    
    @sendInput 1, input.address(), 28
    
  leftMouseClick: =>
    @leftMouseDown()
    @leftMouseUp()
  
  keyboardPress: (key) =>
    # INPUT    Input={0};
    # Input.type      = INPUT_KEYBOARD;
    # Input.ki.wVk = VK_ESCAPE;
    # ::SendInput(1,&Input,sizeof(INPUT));
    code = @keyCodes[key]
    return unless code
    
    input = new @keyboardEvent
    input.type = 1
    input.ki.wVk = code
    
    @sendInput 1, input.address(), 28
