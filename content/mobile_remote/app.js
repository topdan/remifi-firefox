(function() {
  var App,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  App = (function() {

    App.name = 'App';

    MobileRemote.App.Sandbox = App;

    function App(remote, name) {
      this.remote = remote;
      this.name = name;
      this.setMetadata = __bind(this.setMetadata, this);

      this.extractMetadata = __bind(this.extractMetadata, this);

      this.evalInSandbox = __bind(this.evalInSandbox, this);

      this.remote = remote;
      this.name = name;
      this.code = null;
      this.filename = "/apps/" + (name.replace(/\./g, '/')) + ".js";
      this.url = null;
      this.uri = null;
      this.domains = null;
      this.imports = ['lib/json2'];
      this.metadata = {};
      this.sandbox = null;
      this.crossDomains = [];
      this.api = new MobileRemote.Api(this);
      this.code = this.remote.env.fileContent(this.filename);
      this.extractMetadata(this.code, this.setMetadata);
    }

    App.prototype.render = function(uri, request, response) {
      var action, c, hash, json, limitedRequest, sandbox;
      sandbox = this.createSandbox();
      action = request.path.match(/\/([^\/]+)$/);
      if (action) {
        action = action[1];
      }
      limitedRequest = {
        protocol: uri.protocol,
        host: uri.host,
        port: uri.port,
        path: uri.path,
        directory: uri.directory,
        file: uri.file,
        anchor: uri.anchor,
        action: action,
        params: request.params
      };
      json = Components.utils.evalInSandbox("render(" + (JSON.stringify(limitedRequest)) + ");", sandbox);
      if (typeof json === "string") {
        hash = JSON.parse(json);
        c = new MobileRemote.Views.Hash(this, request, response);
        return c.perform(hash);
      } else {
        return null;
      }
    };

    App.prototype.createSandbox = function() {
      var code, file, importName, sandbox, _i, _len, _ref;
      sandbox = this.api.createSandbox(null, {
        zepto: true
      });
      this.evalInSandbox('app', "app = " + (JSON.stringify({
        name: this.name
      })), sandbox);
      _ref = this.imports;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        importName = _ref[_i];
        file = "/apps/" + importName + ".js";
        code = this.remote.env.fileContent(file);
        this.evalInSandbox(file, code, sandbox);
      }
      code = this.remote.env.fileContent(this.filename);
      this.evalInSandbox(this.filename, code, sandbox);
      return sandbox;
    };

    App.prototype.evalInSandbox = function(file, code, sandbox) {
      try {
        return Components.utils.evalInSandbox(code, sandbox);
      } catch (err) {
        throw file + " " + err;
      }
    };

    App.prototype.extractMetadata = function(code, callback) {
      var m, match, matches, regex, _i, _len, _results;
      regex = /\/\/ \@([^\ ]+)[\ ]+([^\n]+)/g;
      if (code === null) {
        return null;
      }
      matches = code.match(regex);
      if (matches) {
        _results = [];
        for (_i = 0, _len = matches.length; _i < _len; _i++) {
          match = matches[_i];
          m = match.match(/\/\/ \@([^\ ]+)[\ ]+([^\n]+)/);
          _results.push(callback(m[1], m[2]));
        }
        return _results;
      }
    };

    App.prototype.setMetadata = function(key, value) {
      switch (key) {
        case 'url':
          this.url = value;
          this.uri = new MobileRemote.URI(this.url);
          this.domains = [this.uri.host];
          break;
        case 'import':
          this.imports.push(value);
          break;
        case 'domain':
          this.domains || (this.domains = []);
          this.domains.push(value);
          break;
        case 'crossdomain':
          this.crossDomains.push(value);
          break;
        default:
          this.metadata[key] = value;
      }
      return value;
    };

    return App;

  })();

}).call(this);
