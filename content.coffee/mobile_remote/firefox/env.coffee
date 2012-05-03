class Env
  MobileRemote.Firefox.Env = Env
  
  constructor: () ->
    @extensionPath = null
    
    profilePath = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("ProfD", Components.interfaces.nsIFile).path

    extensionsPath = profilePath + '/extensions'
    @extensionPath = extensionsPath + '/mobile-remote@topdan.com'
    
    @isDevMode = Application.prefs.getValue('extensions.mobile-remote.development', false)
    @templates = {}
    
    f = @_fileHandle(@extensionPath)
    if f.exists() && !f.isDirectory()
      file = @_fileHandle(@extensionPath)
      @extensionPath = MobileRemote.trim(@_fileContent(file))
  
  fileContent: (path) =>
    path = @_fullpath(path)
    file = @_fileHandle(path)
    if file.exists()
      @_fileContent(file)
    else
      null
  
  template: (viewpath, data) =>
    view = @templates[viewpath]
    
    if view == null || typeof view == 'undefined'
      code = @fileContent(viewpath)
      throw "viewpath not found: " + viewpath if code == null
      
      view = MobileRemote.microtemplate(code)
      @templates[viewpath] = view unless @isDevMode
    
    data ||= {}
    view(data)
  
  exec: (path, args) =>
    path = @_fullpath(path)
    file = @_fileHandle(path)
    
    runner = Components.classes["@mozilla.org/process/util;1"].createInstance(Components.interfaces.nsIProcess)
    runner.init(file)
    runner.run(true, args, args.length)
  
  _fullpath: (path) =>
    @extensionPath + path
  
  _fileHandle: (path) =>
    f = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile)
    f.initWithPath(path)
    f
  
  # https://developer.mozilla.org/en/Code_snippets/File_I%2F%2FO
  _fileContent: (file) =>
    data = ""
    fstream = Components.classes["@mozilla.org/network/file-input-stream;1"].createInstance(Components.interfaces.nsIFileInputStream)
    cstream = Components.classes["@mozilla.org/intl/converter-input-stream;1"].createInstance(Components.interfaces.nsIConverterInputStream)
    
    fstream.init(file, -1, 0, 0)
    cstream.init(fstream, "UTF-8", 0, 0) # you can use another encoding here if you wish
    
    str = {}
    read = 0
    loop
      read = cstream.readString(0xffffffff, str)
      data += str.value
      break if read == 0
    
    cstream.close() # this closes fstream
    
    data
