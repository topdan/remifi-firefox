class Boot
  MobileRemote.Firefox.Boot = Boot
  
  constructor: () ->
    
  load: () ->
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

    remote.port = Application.prefs.getValue('extensions.mobile-remote.port', 6670)
    remote.server = new MobileRemote.Firefox.Server(remote.port);
    remote.server.dynamicRequest = remote.handleRequest;
    remote.server.getStaticFilePath = (request) ->
      if MobileRemote.startsWith(request.fullpath, '/static/')
        env.extensionPath + request.fullpath;

    MobileRemote.instance = remote;
    remote.load();

    firstSplash = "extensions.mobile-remote.firstSplash";
    unless Application.prefs.getValue(firstSplash, false)
      # won't work on the onLoad thread, not sure what event to hook into so just wait a bit
      setTimeout ->
        Application.prefs.setValue(firstSplash, true)
        gBrowser.selectedTab = gBrowser.addTab "http://localhost:#{remote.port}/getting-started/"
      , 1000
  
  unload: () ->
    if MobileRemote.instance && MobileRemote.isReference != true
      MobileRemote.instance.unload();
      MobileRemote.instance = null;
    