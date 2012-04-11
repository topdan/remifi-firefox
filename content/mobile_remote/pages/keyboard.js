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
      
    } else if (request.path == '/keyboard/escape.js') {
      return this.pressEscape(request, response);
      
    } else if (request.path == '/keyboard/return.js') {
      return this.pressReturn(request, response);
      
    // } else if (request.path == '/keyboard/tab-up.js') {
    //   return this.tabUp(request, response);
    //   
    // } else if (request.path == '/keyboard/tab-down.js') {
    //   return this.tabDown(request, response);
      
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
          null, // {title: 'tab up', url: '/keyboard/tab-up.js'},
          null, // {title: 'tab down', url: '/keyboard/tab-down.js'},
        ]);
        
      });
    });
    
  }
  
  this.typeText = function(request, response) {
    var sandbox = remote.createSandbox(null, {zepto: true});
    var text = request.params["text"] || "";
    
    var view = new MobileRemote.Views.Base(remote.env);
    var code = 'Zepto(":focus").val("' + view.escape(text) + '")';
    
    try {
      Components.utils.evalInSandbox(code, sandbox);
    } catch (err) {
      // can't type text onto this page
    }
    
    return this.index(request, response);
  }
  
  this.pressEscape = function(request, response) {
    remote.env.exec("/bin/keyboard", ['-key', 'escape'])
  }
  
  this.pressReturn = function(request, response) {
    remote.env.exec("/bin/keyboard", ['-key', 'return'])
  }
  
  // this.tabUp = function(request, response) {
  //   var sandbox = remote.createSandbox(null, {zepto: true});
  //   try {
  //     var code = "var e = $(':focus').get(0) || $('form').get(0).elements[0]; var f = e.form ; for (var i=0 ; i < f.elements.length ; i++) { if (e == f.elements[i]) { $(f.elements[i+1]).focus(); } }";
  //     
  //     Components.utils.evalInSandbox(code, sandbox);
  //   } catch (err) {
  //     
  //   }
  // }
  // 
  // this.tabDown = function(request, response) {
  //   var sandbox = remote.createSandbox(null, {zepto: true});
  //   try {
  //     var code = "var e = $(':focus').get(0) || $('form').get(0).elements[0]; var f = e.form ; for (var i=0 ; i < f.elements.length ; i++) { if (e == f.elements[i]) { $(f.elements[i-1]).focus(); } }";
  //     
  //     Components.utils.evalInSandbox(code, sandbox);
  //   } catch (err) {
  //     
  //   }
  // }
  
  var currentText = function() {
    try {
      var sandbox = remote.createSandbox(null, {zepto: true});
      var code = 'Zepto(":focus").val()';
      var current = Components.utils.evalInSandbox(code, sandbox);
      if (typeof current == "string") {
        return current;
      }
    } catch (err) {
      return null;
    }
  }
  
}
