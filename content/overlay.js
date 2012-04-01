window.addEventListener("load", function(e) {
  var serverSignature = 'Mobile-Remote/0.1';
  var env = new MobileRemote.Firefox.Env();
  var remote = new MobileRemote.Base(env);
  
  remote.view = new MobileRemote.Firefox.View();
  remote.views = new MobileRemote.Views(env);
  
  remote.server = new MobileRemote.Firefox.Server();
  remote.server.getStaticFilePath = function(request) {
    if (MobileRemote.startsWith(request.fullpath, '/static/')) {
      return env.extensionPath + request.fullpath;
    }
  };
  
  remote.server.staticRequest = function(request, response) {
    response.headers['Server'] = serverSignature;
  }
  
  remote.server.dynamicRequest = function(request, response) {
    response.headers['Content-Type'] = 'text/html'
    response.headers['Server'] = serverSignature
    
    // var isDev = remote.env.doesFileExist(devFile)
    // var isRestart = remote.env.doesFileExist(restartFile)
    // 
    // if (isDev || isRestart) {
    //  remote.plugins.reloadAll()
    //  
    //  if (isRestart)
    //    remote.env.deleteFile(restartFile)
    // }
    
    var controller = new MobileRemote.Controller(remote, request, response);
    return controller.process();
  }
  
  MobileRemote.instance = remote;
  remote.load();
}, false);

window.addEventListener("unload", function(e) { 
  if (MobileRemote.instance) {
    MobileRemote.instance.unload();
    MobileRemote.instance = null;
  }
}, false);
