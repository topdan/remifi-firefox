MobileRemote = {};
MobileRemote.App = {};
MobileRemote.Firefox = {};
MobileRemote.Pages = {};
MobileRemote.Util = {};
MobileRemote.Views = {};

window.addEventListener("load", function(e) {
  // check for the server already running inside another window and copy its reference
  var wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
  var wenum = wm.getEnumerator(null);
  while (wenum.hasMoreElements()) {
    var win = wenum.getNext();
    if (win.MobileRemote.instance) {
      MobileRemote.instance = win.MobileRemote.instance;
      MobileRemote.isReference = true;
      MobileRemote.instance.refresh();
      return;
    }
  }
  
  // the server is not initialized anywhere, so let's do it!
  
  var env = new MobileRemote.Firefox.Env();
  var remote = new MobileRemote.Base(env);
  
  remote.view = new MobileRemote.Firefox.View();
  remote.views = function(callback) {
    var views = new MobileRemote.Views.Base(env);
    callback(views);
    return views.html();
  }
  
  remote.server = new MobileRemote.Firefox.Server();
  remote.server.dynamicRequest = remote.handleRequest;
  remote.server.getStaticFilePath = function(request) {
    if (MobileRemote.startsWith(request.fullpath, '/static/')) {
      return env.extensionPath + request.fullpath;
    }
  };
  
  MobileRemote.instance = remote;
  remote.load();
}, false);

window.addEventListener("unload", function(e) { 
  if (MobileRemote.instance && MobileRemote.isReference != true) {
    MobileRemote.instance.unload();
    MobileRemote.instance = null;
  }
}, false);
