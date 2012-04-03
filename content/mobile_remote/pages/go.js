if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Go = function(remote) {
  
  this.getBody = function(request, response) {
    if (request.path == '/go/index.html' || request.path == '/go/') {
      return this.index(request, response);
      
    } else if (request.path == '/go/url.html') {
      return this.url(request, response);
      
    } else if (request.path == '/go/google.html') {
      return this.google(request, response);
      
    }
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      v.page('go', function() {
        v.toolbar('Go', {right: {title: 'home', url: '/'}});
        
        v.form('/go/url.html', function(f) {
          f.url('url', {placeholder: 'Web Address'})
        })
        
        v.form('/go/google.html', function(f) {
          f.search('q', {placeholder: 'Google Search'})
        })
      });
    });
  };
  
  this.url = function(request, response) {
    var url = request.params["url"]
    if (url) {
      return this.visit(url, request, response);
    } else {
      return this.index(request, response);
    }
  }
  
  this.google = function(request, response) {
    var search = request.params["q"]
    if (search) {
      var url = 'http://www.google.com/search?q=' + encodeURIComponent(search) + '&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a';
      return this.visit(url, request, response)
    } else {
      return this.index(request, response);
    }
  }
  
  this.visit = function(url, request, response) {
    if (!(MobileRemote.startsWith(url, 'http://') || MobileRemote.startsWith(url, 'https://'))) {
      url = "http://" + url
    }
    remote.currentBrowser().contentDocument.location.href = url;
    return this.index(request, response);
  }
  
};
