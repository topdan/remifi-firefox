if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Bookmarklets = function(remote) {
  
  this.render = function(request, response) {
    if (request.path == '/bookmarklets/index.html' || request.path == '/bookmarklets/') {
      return this.index(request, response);
      
    } else if (request.path == '/bookmarklets/new-tab.html') {
      return this.newTab(request, response);
      
    } else if (request.path == '/bookmarklets/new-window.html') {
      return this.newWindow(request, response);
      
    } else if (request.path == '/bookmarklets/visit.html') {
      return this.visit(request, response);
      
    }
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      v.page('bookmarklets-page', function() {
        v.toolbar();
        v.title("Bookmarklets");
        
        var referer = request.headers["Referer"];
        referer = referer.match('(http://[^\/]+)')[0];
        var viewJS = "javascript:document.location = '" + referer + "/bookmarklets/visit.html?url=' + encodeURIComponent(document.location.href);";
        var newTab = "javascript:document.location = '" + referer + "/bookmarklets/new-tab.html?url=' + encodeURIComponent(document.location.href);";
        var newWindow = "javascript:document.location = '" + referer + "/bookmarklets/new-window.html?url=' + encodeURIComponent(document.location.href);";
        
        v.template('/views/bookmarklets.html', {viewJS: viewJS, newTab: newTab, newWindow: newWindow});
        
      });
    });
  };
  
  this.visit = function(request, response) {
    remote.pages.controls.visit(request, response);
    return remote.pages.controls.wait('/', request, response);
  };
  
  this.newTab = function(request, response) {
    remote.pages.tabs.add(request, response);
    return remote.pages.controls.wait('/', request, response);
  };
  
  this.newWindow = function(request, response) {
    remote.pages.windows.add(request, response);
    return remote.pages.controls.wait('/', request, response);
  };
  
};
