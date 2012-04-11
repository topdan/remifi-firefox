if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Keyboard = function(remote) {
  var self = this;
  
  this.delay = 200;
  this.program = "/bin/keyboard";
  
  this.x = null;
  this.y = null;
  
  this.render = function(request, response) {
    if (request.path == '/keyboard/index.html' || request.path == '/keyboard/') {
      return this.index(request, response);
      
    } else if (request.path == '/keyboard/type.html') {
      return this.typeText(request, response);
      
    }
  }
  
  this.index = function(request, response) {
    return remote.views(function(v) {
      v.page('keyboard-page', function() {
        v.toolbar();
        
        v.template('/views/keyboard.html', {current: currentText()});
        
        v.systemApps([
          {title: 'mouse', url: '/mouse/'},
          null,
          {title: 'page up', url: '/mouse/page-up.js'},
          {title: 'page down', url: '/mouse/page-down.js'},
        ]);
        
      });
    });
    
  }
  
  this.typeText = function(request, response) {
    var sandbox = remote.createSandbox(null, {zepto: true});
    var text = request.params["text"] || "";
    
    var view = new MobileRemote.Views.Base(remote.env);
    var code = 'Zepto(":focus").val("' + view.escape(text) + '")';
    Components.utils.evalInSandbox(code, sandbox);
    
    return this.index(request, response);
  }
  
  var currentText = function() {
    var sandbox = remote.createSandbox(null, {zepto: true});
    
    var code = 'Zepto(":focus").val()';
    var current = Components.utils.evalInSandbox(code, sandbox);
    if (typeof current == "string") {
      return current;
    }
  }
  
}
