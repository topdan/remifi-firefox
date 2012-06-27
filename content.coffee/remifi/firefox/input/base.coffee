class Base
  Remifi.Firefox.Input.Base = Base
  
  Remifi.Firefox.Input.build = (remote) ->
    if remote.env.isWindows
      new Remifi.Firefox.Input.Win32()
    else if remote.env.isLinux
      new Remifi.Firefox.Input.X11(remote)
    else if remote.env.isOSX
      new Remifi.Firefox.Input.OSX()
    else
      Components.utils.reportError "Remifi doesn't support your operating system. Mouse and keyboard will not work"
      new Remifi.Firefox.Input.Base()
  
  constructor: ->
    
  mouseClick: (x, y) =>
    # subclass
    
  mouseOver: (x, y) =>
    # subclass

  # supports 'escape' and 'return'
  keyboardPress: (key) =>
    # subclass

  exec: (path, args) =>
    path = @remote.env._fullpath(path)
    file = @remote.env._fileHandle(path)

    runner = Components.classes["@mozilla.org/process/util;1"].createInstance(Components.interfaces.nsIProcess)
    runner.init(file)
    runner.run(true, args, args.length)
