(function() {
  var Overlay, onLoad, unLoad;

  window.MobileRemote = {};

  Overlay = (function() {

    Overlay.name = 'Overlay';

    function Overlay() {}

    MobileRemote.App = {};

    MobileRemote.Firefox = {};

    MobileRemote.Pages = {};

    MobileRemote.Util = {};

    MobileRemote.Views = {};

    return Overlay;

  })();

  onLoad = function(e) {
    var env, remote, wenum, win, wm;
    wm = Components.classes["@mozilla.org/appshell/window-mediator;1"].getService(Components.interfaces.nsIWindowMediator);
    wenum = wm.getEnumerator(null);
    while (true) {
      if (!wenum.hasMoreElements()) {
        break;
      }
      win = wenum.getNext();
      if (win.MobileRemote.instance) {
        MobileRemote.instance = win.MobileRemote.instance;
        MobileRemote.isReference = true;
        MobileRemote.instance.refresh();
        return;
      }
    }
    env = new MobileRemote.Firefox.Env();
    remote = new MobileRemote.Base(env);
    remote.view = new MobileRemote.Firefox.View();
    remote.views = function(callback) {
      var views;
      views = new MobileRemote.Views.Base(env);
      callback(views);
      return views.html();
    };
    remote.server = new MobileRemote.Firefox.Server();
    remote.server.dynamicRequest = remote.handleRequest;
    remote.server.getStaticFilePath = function(request) {
      if (MobileRemote.startsWith(request.fullpath, '/static/')) {
        return env.extensionPath + request.fullpath;
      }
    };
    MobileRemote.instance = remote;
    return remote.load();
  };

  unLoad = function(e) {
    if (MobileRemote.instance && MobileRemote.isReference !== true) {
      MobileRemote.instance.unload();
      return MobileRemote.instance = null;
    }
  };

  window.addEventListener("load", onLoad, false);

  window.addEventListener("unload", unLoad, false);

}).call(this);
