if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Controls = function(remote) {
  var self = this;
  
  this.getBody = function(request, response) {
    if (request.path == '/controls/index.html' || request.path == '/controls/') {
      return this.index(request, response);
      
    } else if (request.path == '/controls/home.html') {
      return this.home(request, response);
      
    } else if (request.path == '/controls/stop.html') {
      return this.stop(request, response);
      
    } else if (request.path == '/controls/refresh.html') {
      return this.refresh(request, response);
      
    } else if (request.path == '/controls/back.html') {
      return this.back(request, response);
      
    } else if (request.path == '/controls/forward.html') {
      return this.forward(request, response);
      
    } else if (request.path == '/controls/wait.html') {
      return this.wait(request, response);
      
    } else if (request.path == '/controls/wait.js') {
      return this.waitJS(request, response);
    }
  }
  
  this.home = function(request, response) {
    remote.currentBrowser().goHome();
    return this.wait(request.params['url'] || '/controls/index.html', request, response);
  }
  
  this.stop = function(request, response) {
    remote.currentBrowser().stop();
    return this.wait(request.params['url'] || '/controls/index.html', request, response);
  }
  
  this.refresh = function(request, response) {
    var doc = remote.currentBrowser().contentDocument;
    doc.location.href = doc.location.href;
    return this.wait(request.params['url'] || '/controls/index.html', request, response);
  }
  
  this.back = function(request, response) {
    remote.currentBrowser().goBack();
    return this.wait(request.params['url'] || '/controls/index.html', request, response);
  }
  
  this.forward = function(request, response) {
    remote.currentBrowser().goForward();
    return this.wait(request.params['url'] || '/controls/index.html', request, response);
  }
  
  this.wait = function(url, request, response) {
    return remote.views(function(v) {
      v.page('controls', function() {
        v.toolbar('Controls', {right: {title: 'home', url: '/'}});
        
        v.content.push('<div id="waiting"><p class="wait-message"><span class="title">Loading...</span><br/><img src="/static/images/loading.gif" width="220" height="19"/><br/><span class="description">&nbsp;</span></p></div>')
        v.content.push('<script type="text/javascript">$(function() { mobileRemote.wait("' + url + '"); })</script>');
        
        self.buttons(v, url);
      });
    });
  }
  
  this.waitJS = function(request, response) {
    var url = request.params["url"];
    if (remote.currentBrowser().webProgress.isLoadingDocument) {
      return 'setTimeout(function() { mobileRemote.wait("' + url + '")}, 250);'
    } else {
      return 'mobileRemote.show("' + url + '")'
    }
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      v.page('controls', function() {
        v.toolbar('Controls', {right: {title: 'home', url: '/'}});
        
        v.template('/views/mouse.html', {});
        
        self.buttons(v);
      });
    });
  };
  
  this.buttons = function(v, url) {
    if (url == null) url = '/controls/index.html';
    var browser = remote.currentBrowser();
    
    url = encodeURIComponent(url);
    
    var back = browser.canGoBack ? {title: 'back', url: '/controls/back.html?url=' + url} : null;
    var home = {title: 'home', url: '/controls/home.html?url=' + url};
    
    var stop = null;
    if (browser.webProgress.isLoadingDocument)
      stop = {title: 'stop', url: '/controls/stop.html?url=' + url};
    else
      stop = {title: 'refresh', url: '/controls/refresh.html?url=' + url}
    
    var forward = browser.canGoForward ? {title: 'forward', url: '/controls/forward.html?url=' + url} : null;
    
    v.systemApps([back, home, stop, forward]);
  }
  
};