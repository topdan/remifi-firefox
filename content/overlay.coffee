# the extension's namespace
window.MobileRemote = {};

class Overlay
  MobileRemote.App = {};
  MobileRemote.Firefox = {};
  MobileRemote.Pages = {};
  MobileRemote.Util = {};
  MobileRemote.Views = {};

onLoad = (e) ->
  # check for the server already running inside another window and copy its reference
  wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
  wenum = wm.getEnumerator(null);
  loop
    break unless wenum.hasMoreElements()
    
    win = wenum.getNext();
    if win.MobileRemote.instance
      MobileRemote.instance = win.MobileRemote.instance;
      MobileRemote.isReference = true;
      MobileRemote.instance.refresh();
      return
  
  # the server is not initialized anywhere, so let's do it!
  env = new MobileRemote.Firefox.Env();
  remote = new MobileRemote.Base(env);
  
  remote.view = new MobileRemote.Firefox.View();
  remote.views = (callback) ->
    views = new MobileRemote.Views.Base(env);
    callback(views);
    views.html();
  
  remote.server = new MobileRemote.Firefox.Server();
  remote.server.dynamicRequest = remote.handleRequest;
  remote.server.getStaticFilePath = (request) ->
    if MobileRemote.startsWith(request.fullpath, '/static/')
      env.extensionPath + request.fullpath;
  
  MobileRemote.instance = remote;
  remote.load();

unLoad = (e) ->
  if MobileRemote.instance && MobileRemote.isReference != true
    MobileRemote.instance.unload();
    MobileRemote.instance = null;

window.addEventListener "load", onLoad, false
window.addEventListener "unload", unLoad, false
