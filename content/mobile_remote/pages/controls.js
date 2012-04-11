if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Controls = function(remote) {
  var self = this;
  
  this.render = function(request, response) {
    if (request.path == '/controls/home.html') {
      return this.home(request, response);
      
    } else if (request.path == '/controls/stop.html') {
      return this.stop(request, response);
      
    } else if (request.path == '/controls/refresh.html') {
      return this.refresh(request, response);
      
    } else if (request.path == '/controls/back.html') {
      return this.back(request, response);
      
    } else if (request.path == '/controls/forward.html') {
      return this.forward(request, response);
      
    } else if (request.path == '/controls/visit.html') {
      return this.visit(request, response);
      
    } else if (request.path == '/controls/google.html') {
      return this.google(request, response);
      
    } else if (request.path == '/controls/wait.html') {
      return this.wait(request, response);
      
    } else if (request.path == '/controls/wait.js') {
      return this.waitJS(request, response);
      
    }
  }
  
  this.home = function(request, response) {
    remote.currentBrowser().goHome();
    return this.wait(request.params['url'], request, response);
  }
  
  this.stop = function(request, response) {
    remote.currentBrowser().stop();
    return this.wait(request.params['url'], request, response);
  }
  
  this.refresh = function(request, response) {
    var doc = remote.currentBrowser().contentDocument;
    doc.location.href = doc.location.href;
    return this.wait(request.params['url'], request, response);
  }
  
  this.back = function(request, response) {
    remote.currentBrowser().goBack();
    return this.wait(request.params['url'], request, response);
  }
  
  this.forward = function(request, response) {
    remote.currentBrowser().goForward();
    return this.wait(request.params['url'], request, response);
  }
  
  this.visit = function(request, response) {
    var url = this.polishURL(request.params["url"]);
    
    if (url)
      remote.currentBrowser().contentDocument.location.href = url;
    
    return self.wait('/', request, response);
  }
  
  this.google = function(request, response) {
    var search = request.params["q"] || "";
    request.params.url = 'http://www.google.com/search?q=' + encodeURIComponent(search) + '&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a';
    return this.visit(request, response)
  }
  
  this.wait = function(url, request, response) {
    return remote.views(function(v) {
      v.page('controls', function() {
        v.toolbar({stop: true});
        
        v.out.push('<div id="waiting"><p class="wait-message"><span class="title">Loading...</span><br/><img src="/static/images/loading.gif" width="220" height="19"/><br/><span class="description">&nbsp;</span></p></div>')
        v.out.push('<script type="text/javascript">$(function() { mobileRemote.wait("' + url + '"); })</script>');
      });
    });
  }
  
  this.polishURL = function(url) {
    if (url == null || url == "") {
      // do nothing
    } else if (!MobileRemote.startsWith(url, 'http://') && !MobileRemote.startsWith(url, 'https://')) {
      url = "http://" + url;
    }
    
    return url;
  }
  
  this.waitJS = function(request, response) {
    var url = request.params["url"];
    if (remote.currentBrowser().webProgress.isLoadingDocument) {
      return 'setTimeout(function() { mobileRemote.wait("' + url + '")}, 250);'
    } else {
      return 'mobileRemote.show("' + url + '")'
    }
  }
  
};
