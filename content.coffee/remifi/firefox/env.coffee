class Env
  Remifi.Firefox.Env = Env
  
  constructor: () ->
    @extensionPath = null
    
    profilePath = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("ProfD", Components.interfaces.nsIFile).path

    extensionsPath = profilePath + '/extensions'
    @extensionPath = extensionsPath + '/remifi@topdan.com'
    
    @isDevMode = Application.prefs.getValue('extensions.remifi.development', false)
    @isWindows = navigator.oscpu.match(/Windows/) != null
    @templates = {}
    
    f = @_fileHandle(@extensionPath)
    if f.exists() && !f.isDirectory()
      file = @_fileHandle(@extensionPath)
      @extensionPath = Remifi.trim(@_fileContent(file))
      @extensionPath = @extensionPath.substring(0, @extensionPath.length - 1) if @isWindows
  
  fileContent: (path) =>
    path = @_fullpath(path)
    file = @_fileHandle(path)
    if file.exists()
      @_fileContent(file)
    else
      null
  
  eachFile: (dir, callback) =>
    f = @_fileHandle @_fullpath(dir) + "/"
    dirStack = new Array({entry: f, path: ""});

    return unless f.exists()

    while dirStack.length
      e = dirStack.pop()
      dir = e.entry
      path = e.path

      entries = dir.directoryEntries

      continueRecurse = true
      childDirectories = []

      while entries.hasMoreElements()
        entry = entries.getNext()
        entry.QueryInterface(Components.interfaces.nsIFile)

        if entry.isDirectory()
          if dir == f
            p = ''
          else
            p = path + '/' + dir.leafName
          
          childDirectories.push
            entry: entry,
            path: p

        else
          if dir == f
            r = callback entry.leafName
          else
            r = callback "#{path}/#{dir.leafName}/#{entry.leafName}"

            continueRecurse = false if r == false

      if continueRecurse
        dirStack = dirStack.concat(childDirectories)
  
  template: (viewpath, data) =>
    view = @templates[viewpath]
    
    if view == null || typeof view == 'undefined'
      code = @fileContent(viewpath)
      throw "viewpath not found: " + viewpath if code == null
      
      view = Remifi.microtemplate(code)
      @templates[viewpath] = view unless @isDevMode
    
    data ||= {}
    view(data)
  
  rawTemplate: (viewpath) =>
    view = @templates[viewpath]
    
    if view == null || typeof view == 'undefined'
      view = @fileContent(viewpath)
      throw "viewpath not found: " + viewpath if view == null
      
      @templates[viewpath] = view unless @isDevMode
    
    view
    
  
  polishPath: (path) =>
    if @isWindows
      path.replace(/\//g, '\\')
    else
      path
  
  exec: (path, args) =>
    path = @_fullpath(path)
    file = @_fileHandle(path)
    
    runner = Components.classes["@mozilla.org/process/util;1"].createInstance(Components.interfaces.nsIProcess)
    runner.init(file)
    runner.run(true, args, args.length)
  
  _fullpath: (path) =>
    @extensionPath + path
  
  _fileHandle: (path) =>
    path = @polishPath path
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
