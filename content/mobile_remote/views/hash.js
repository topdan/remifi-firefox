if (MobileRemote.Views == null) MobileRemote.Views = {}

MobileRemote.Views.Hash = function(app, request, response) {
  var self = this;
  var pageCount = 0;
  var view = null;
  
  this.perform = function(items) {
    var type = items.type;
    
    if (type == 'wait') {
      return app.remote.pages.controls.wait('/', request, response);
      
    } else if (type == 'pages' && typeof items.content == "object" && items.content.length > 0) {
      return app.remote.views(function(v) {
        view = v;
        self.performArray(items.content, self.pageTypes);
      })
    }
  }
  
  this.pageTypes = {};
  
  this.pageTypes.page = function(hash) {
    pageCount++;
    var id = hash.id || "app-page-" + pageCount;
    
    view.page(id, function() {
      if (hash.content)
        self.performArray(hash.content, self.pageTypes);
    })
  }
  
  this.pageTypes.toolbar = function(hash) {
    view.toolbar();
  }
  
  this.pageTypes.title = function(hash) {
    view.title(hash.name);
  }
  
  this.pageTypes.button = function(hash) {
    var url = actionUrlFor(hash.url)
    view.button(hash.name, url, {type: hash.buttonType, disabled: hash.disabled})
  }
  
  this.pageTypes.mouse = function(hash) {
    var action = hash.action;
    var delay = hash.delay;
    var x = hash.x;
    var y = Math.max(hash.y, 25);
    
    switch (action) {
      case 'click':
        app.remote.pages.mouse.action('click', delay, x, y);
        break;
      case 'over':
        app.remote.pages.mouse.action('over', delay, x, y);
        break
    }
  }
  
  this.pageTypes.keyboard = function(hash) {
    var action = hash.action;
    var key = hash.key;
    
    switch (action) {
      case 'press':
        app.remote.pages.keyboard.press(hash.key);
        break;
    }
  }
  
  this.pageTypes.fullscreen = function(hash) {
    app.remote.currentDocument().mobileRemoteFullscreen = hash.value == true
  }
  
  this.pageTypes.br = function(hash) {
    view.br();
  }
  
  this.pageTypes.form = function(hash) {
    if (self.currentForm) return
    
    var url = actionUrlFor(hash.action);
    view.form(url, function(f) {
      self.currentForm = f;
      
      if (hash.content)
        self.performArray(hash.content, self.form);
      
      self.currentForm = null;
    })
  }
  
  this.pageTypes.error = function(hash) {
    view.error(hash.message);
  }
  
  this.pageTypes.paginate = function(hash) {
    view.paginate(hash.items);
  }
  
  this.pageTypes.list = function(hash) {
    view.list(hash.items, {rounded: hash.rounded});
  }
  
  this.pageTypes.apps = function(hash) {
    
  }
  
  this.pageTypes.systemApps = function(hash) {
    
  }
  
  this.form = {}
  
  this.form.fieldset = function(hash) {
    self.currentForm.fieldset(function() {
      if (hash.content)
        self.performArray(hash.content, self.form);
    })
  }
  
  this.form.br = function(hash) {
    self.currentForm.br()
  }
  
  this.form.url = function(hash) {
    self.currentForm.url(hash.name, {placeholder: hash.placeholder, value: hash.value})
  }
  
  this.form.search = function(hash) {
    self.currentForm.search(hash.name, {placeholder: hash.placeholder, value: hash.value})
  }
  
  this.form.submit = function(hash) {
    var url = '#';
    self.currentForm.submit(hash.name, url, {placeholder: hash.placeholder, value: hash.value})
  }
  
  this.performArray = function(array, types) {
    for (var i=0 ; i < array.length ; i++) {
      var item = array[i];
      
      if (typeof item == "object") {
        var type = item["type"];
        var convert = types[type];
        if (convert)
          convert(item);
      }
    }
  }
  
  var actionUrlFor = function(action) {
    return '/apps/' + app.name + '/' + action;
  }
  
}
