MobileRemote.App = {}

// eventually this will be one base class that uses a sandbox to
// allow downloaded apps to produce a neat remote UI for webpages

MobileRemote.App.Sandbox = function(remote, name) {
  var self = this;
  
  this.remote = remote;
  this.name = name;
  this.code = null;
  this.filename = '/apps/' + name.replace(/\./g, '/') + '.js';
  this.url = null;
  this.uri = null;
  this.domains = null;
  this.imports = ['lib/json2'];
  this.metadata = {};
  this.sandbox = null;
  this.crossDomains = [];
  
  var init = function() {
    self.code = remote.env.fileContent(self.filename);
    extractMetadata(self.code, setMetadata);
  }
  
  this.render = function(uri, request, response) {
    var sandbox = createSandbox();
    
    var action = request.path.match(/\/([^\/]+)$/)
    if (action) action = action[1];
    
    var limitedRequest = {
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
    
    var json = Components.utils.evalInSandbox('render(' + JSON.stringify(limitedRequest) + ');', sandbox);
    
    if (typeof json == "string") {
      var hash = JSON.parse(json);
      var c = new MobileRemote.Views.Hash(self, request, response);
      return c.perform(hash);
    } else {
      return null;
    }
  }
  
  var createSandbox = function() {
    var sandbox = remote.createSandbox(null, {zepto: true});
    sandbox.importFunction(crossDomainGet);
    evalInSandbox('app', 'app = ' + JSON.stringify({name: self.name}), sandbox)
    
    for (var i=0 ; i < self.imports.length ; i++) {
      var file = '/apps/' + self.imports[i] + '.js';
      var code = remote.env.fileContent(file);
      evalInSandbox(file, code, sandbox);
    }
    
    // OPTIMIZE save this once there's a development reload mode going
    var code = remote.env.fileContent(self.filename);
    evalInSandbox(self.filename, code, sandbox);
    return sandbox;
  }
  
  function crossDomainGet(url) {
    // SECURITY TODO: get the domain's crossdomain.xml and see if it allows from this domain
    // TODO: timeout protection
    
    if (typeof url != "string")
      return null;
    
    var uri = new MobileRemote.URI(url);
    if (self.crossDomains.indexOf(uri.host) == -1)
      return null;
    
    var request = new XMLHttpRequest();
    request.open('GET', url, false);
    request.send(null);
    
    if (request.status === 200) {
      return request.responseText;
    } else {
      return null;
    }
  }
  
  var evalInSandbox = function(file, code, sandbox) {
    try {
      Components.utils.evalInSandbox(code, sandbox);
    } catch (err) {
      throw file + " " + err;
    }
  }
  
  var extractMetadata = function(code, callback) {
    var regex = /\/\/ \@([^\ ]+)[\ ]+([^\n]+)/g
    
    if (code == null) return null;
    
    var matches = code.match(regex)
    if (matches) {
      for (var i=0 ; i < matches.length ; i++) {
        var match = matches[i];
        var m = match.match(/\/\/ \@([^\ ]+)[\ ]+([^\n]+)/)
        callback(m[1], m[2]);
      }
    }
  }
  
  var setMetadata = function(key, value) {
    switch(key) {
      case 'url':
        self.url = value
        self.uri = new MobileRemote.URI(self.url);
        self.domains = [self.uri.host];
        break;
      
      case 'import':
        self.imports.push(value)
        break;
      
      case 'domain':
        if (self.domains == null)
          self.domains = [];
        self.domains.push(value);
        break;
        
      case 'crossdomain':
        self.crossDomains.push(value);
        break;
        
      default:
        self.metadata[key] = value
        break;
    }
  }
  
  init();
}
