(function() {
  var Env,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Env = (function() {

    Env.name = 'Env';

    MobileRemote.Firefox.Env = Env;

    function Env() {
      this._fileContent = __bind(this._fileContent, this);

      this._fileHandle = __bind(this._fileHandle, this);

      this._fullpath = __bind(this._fullpath, this);

      this.exec = __bind(this.exec, this);

      this.template = __bind(this.template, this);

      this.fileContent = __bind(this.fileContent, this);

      var extensionsPath, f, file, profilePath;
      this.extensionPath = null;
      profilePath = Components.classes["@mozilla.org/file/directory_service;1"].getService(Components.interfaces.nsIProperties).get("ProfD", Components.interfaces.nsIFile).path;
      extensionsPath = profilePath + '/extensions';
      this.extensionPath = extensionsPath + '/mobile-remote@topdan.com';
      f = this._fileHandle(this.extensionPath);
      if (f.exists() && !f.isDirectory()) {
        file = this._fileHandle(this.extensionPath);
        this.extensionPath = MobileRemote.trim(this._fileContent(file));
      }
    }

    Env.prototype.fileContent = function(path) {
      var file;
      path = this._fullpath(path);
      file = this._fileHandle(path);
      if (file.exists()) {
        return this._fileContent(file);
      } else {
        return null;
      }
    };

    Env.prototype.template = function(viewpath, data) {
      var code, func;
      code = this.fileContent(viewpath);
      if (code === null) {
        throw "viewpath not found: " + viewpath;
      }
      func = MobileRemote.microtemplate(code);
      data || (data = {});
      return func(data);
    };

    Env.prototype.exec = function(path, args) {
      var file, runner;
      path = this._fullpath(path);
      file = this._fileHandle(path);
      runner = Components.classes["@mozilla.org/process/util;1"].createInstance(Components.interfaces.nsIProcess);
      runner.init(file);
      return runner.run(true, args, args.length);
    };

    Env.prototype._fullpath = function(path) {
      return this.extensionPath + path;
    };

    Env.prototype._fileHandle = function(path) {
      var f;
      f = Components.classes["@mozilla.org/file/local;1"].createInstance(Components.interfaces.nsILocalFile);
      f.initWithPath(path);
      return f;
    };

    Env.prototype._fileContent = function(file) {
      var cstream, data, fstream, read, str;
      data = "";
      fstream = Components.classes["@mozilla.org/network/file-input-stream;1"].createInstance(Components.interfaces.nsIFileInputStream);
      cstream = Components.classes["@mozilla.org/intl/converter-input-stream;1"].createInstance(Components.interfaces.nsIConverterInputStream);
      fstream.init(file, -1, 0, 0);
      cstream.init(fstream, "UTF-8", 0, 0);
      str = {};
      read = 0;
      while (true) {
        read = cstream.readString(0xffffffff, str);
        data += str.value;
        if (read === 0) {
          break;
        }
      }
      cstream.close();
      return data;
    };

    return Env;

  })();

}).call(this);
