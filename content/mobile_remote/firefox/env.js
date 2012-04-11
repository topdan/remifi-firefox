if (MobileRemote.Firefox == null) MobileRemote.Firefox = {}

MobileRemote.Firefox.Env = function() {
  var self = this;
  
  this.extensionPath = null;
  
  this.init = function() {
    var profilePath = Components.classes["@mozilla.org/file/directory_service;1"].getService( Components.interfaces.nsIProperties).get("ProfD", Components.interfaces.nsIFile).path;

    var extensionsPath = profilePath + '/extensions';
    this.extensionPath = extensionsPath + '/mobile-remote@topdan.com';
    
    var f = fileHandle(this.extensionPath)
    if (f.exists() && !f.isDirectory()) {
      var file = fileHandle(this.extensionPath);
      this.extensionPath = MobileRemote.trim(fileContent(file));
    }
  };
  
  this.fileContent = function(path) {
    var path = fullpath(path);
    var file = fileHandle(path);
    if (file.exists())
      return fileContent(file);
    else
      return null;
  }
  
  this.template = function(viewpath, data) {
    var code = this.fileContent(viewpath);
    if (code == null)
      throw "viewpath not found: " + viewpath;
    
    var func = MobileRemote.microtemplate(code);
    return data ? func(data) : func();
  }
  
  this.exec = function(path, args) {
    var path = fullpath(path)
    var file = fileHandle(path)
    
    var runner = Components.classes["@mozilla.org/process/util;1"].createInstance(Components.interfaces.nsIProcess)
    runner.init(file)
    runner.run(true, args, args.length)
  }
  
  var fullpath = function(path) {
    return self.extensionPath + path
  }

  var fileHandle = function(path) {
    var f = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
    f.initWithPath(path);
    return f;
  }

  // https://developer.mozilla.org/en/Code_snippets/File_I%2F%2FO
  var fileContent = function(file) {
    var data = "";
    var fstream = Components.classes["@mozilla.org/network/file-input-stream;1"].createInstance(Components.interfaces.nsIFileInputStream);
    var cstream = Components.classes["@mozilla.org/intl/converter-input-stream;1"].createInstance(Components.interfaces.nsIConverterInputStream);
    
    fstream.init(file, -1, 0, 0);
    cstream.init(fstream, "UTF-8", 0, 0); // you can use another encoding here if you wish
    
    var str = {};
    var read = 0;
    do {
      read = cstream.readString(0xffffffff, str); // read as much as we can and put it in str.value
      data += str.value;
    } while (read != 0);
    
    cstream.close(); // this closes fstream
    
    return data;
  }

  this.init();
};