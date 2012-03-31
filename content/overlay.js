window.addEventListener("load", function(e) {
  var serverSignature = 'Mobile-Remote/0.1';
  var env = new MobileRemote.Firefox.Env();
  var remote = new MobileRemote.Base(env);
  
  remote.server = new MobileRemote.Firefox.Server();
  remote.server.filePath = function(request) {
    if (MobileRemote.startsWith(request.fullpath, '/static/')) {
      return env.extensionPath + request.fullpath;
    }
  };
  
  remote.server.fileRequest = function(request, response) {
    response.headers['Server'] = serverSignature;
  }
  
  remote.server.pageRequest = function(request, response) {
    // response.headers['Content-Type'] = 'text/html'
    // response.headers['Server'] = serverSignature
    // 
    // var isDev = remote.env.doesFileExist(devFile)
    // var isRestart = remote.env.doesFileExist(restartFile)
    // 
    // if (isDev || isRestart) {
    //  remote.plugins.reloadAll()
    //  
    //  if (isRestart)
    //    remote.env.deleteFile(restartFile)
    // }
    // 
    // var controller = new MobileRemote.Controller(remote, request, response, remote.tabs.current())
    // return controller.process(request);
  }
  
  MobileRemote.instance = remote;
  remote.load();
}, false);

window.addEventListener("unload", function(e) { 
  if (MobileRemote.singleton) {
    MobileRemote.instance.unload();
    MobileRemote.instance = null;
  }
}, false);
