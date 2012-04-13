this.routes = {};

function route(path, funcName, block) {
  var route = {path: path, funcName: funcName, actions: []};
  var context = {};
  
  this.currentRoute = route;
  if (block)
    block.call(context);
  this.currentRoute = null;
  
  this.routes[path] = route;
}

function action(name, funcName) {
  if (currentRoute) {
    if (funcName == null) 
      funcName = name;
    currentRoute.actions.push({name: name, funcName: funcName})
  }
}

function render(request) {
  var route = null;
  var action = null;
  
  $.each(this.routes, function(index, p) {
    if (request.path == p.path) 
      route = p;
  })
  
  if (route == null)
    return null;
  
  if (request.action) {
    $.each(route.actions, function(index, a) {
      if (request.action == a.name) 
        action = a;
    })
  }
  
  var handler = null;
  if (action)
    handler = this[action.funcName];
  else
    handler = this[route.funcName]
  
  this.request = request;
  if (typeof handler == 'function')
    handler(request);
  else
    throw "Function not found: " + action.funcName || route.funcName;
  this.request = null;
  
  if (this.isWaiting)
    this.pages = {type: 'wait'}
  
  return JSON.stringify(this.pages);
}

this.isWaiting = false;
this.pages = {type: 'pages', content: []};

function wait() {
  this.isWaiting = true
}

function ensurePage() {
  if (this.pages.content.length == 0) {
    this.pages.content.push({type: 'page', content: []});
    
    if (this.header)
      toolbar(this.header)
  }
}

function page(id, callback) {
  this.pages.content.push({type: 'page', id: id, content: []})
  
  if (this.header)
    toolbar(this.header)
  
  callback();
}

function externalURL(url) {
  if (this.request == null || url == null) return;
  
  // absolute url using same protocol
  if (url.match(/^\/\//)) {
    return this.request.protocol + ":" + url;
    
  // absolute path with same protocol and host
  } else if (url.match(/^\//)) {
    return this.request.protocol + "://" + this.request.host + url;
    
  // absolute url
  } else if (url.match(/^http:\/\//) || (url.match(/^http:\/\//))) {
    return url;
    
  // relative url
  } else {
    var i = this.request.path.lastIndexOf('/');
    var dir = this.request.path.substring(0, i);
    return this.request.protocol + "://" + this.request.host + dir + '/' + url
  }
}

function currentPage() {
  ensurePage();
  return this.pages.content[this.pages.content.length - 1].content;
}

function mouseClick(x, y, delay) {
  currentPage().push({type: 'mouse', action: 'click', x: x, y: y, delay: delay});
}

function mouseOver(x, y, delay) {
  currentPage().push({type: 'mouse', action: 'over', x: x, y: y, delay: delay});
}

function keyboardPress(key) {
  currentPage().push({type: 'keyboard', action: 'press', key: key});
}

function fullscreen(bool) {
  document.isFullscreen = bool == true
  currentPage().push({type: 'fullscreen', value: document.isFullscreen})
}

function toolbar(name) {
  currentPage().push({type: 'toolbar', name: name});
}

function title(name) {
  currentPage().push({type: 'title', name: name});
}

function br() {
  currentPage().push({type: 'br'});
}

function button(name, url, options) {
  if (options == null) options = {};
  currentPage().push({type: 'button', name: name, url: url, buttonType: options.type, disabled: options.disabled});
}

function error(message) {
  currentPage().push({type: 'error', text: message});
}

function list(items, options) {
  if (options == null) options = {};
  currentPage().push({type: 'list', items: items, rounded: options.rounded});
}

function paginate(items) {
  currentPage().push({type: 'paginate', items: items})
}

function form(action, callback) {
  var form = new Form();
  callback(form);
  currentPage().push({type: 'form', action: action, content: form.toArray()});
}

function mergeHash(hash1, hash2) {
  var result = {}
  
  for (var key in hash1) {
    result[key] = hash1[key]
  }
  
  for (var key in hash2) {
    result[key] = hash2[key]
  }
  
  return result;
}

Form = function() {
  
  this.content = [];
  this.currentFieldset = null;
  
  this.toArray = function() {
    return this.content;
  }
  
  this.out = function(hash) {
    if (this.currentFieldset)
      this.currentFieldset.content.push(hash)
    else
      this.content.push(hash)
  }
  
  this.fieldset = function(callback) {
    this.currentFieldset = {type: 'fieldset', content: []};
    callback();
    this.content.push(this.currentFieldset);
    this.currentFieldset = null;
  }
  
  this.br = function() {
    this.out({type: 'br'});
  }
  
  this.url = function(name, options) {
    this.input('url', name, options);
  }
  
  this.search = function(name, options) {
    this.input('search', name, options);
  }
  
  this.submit = function(name, options) {
    this.input('submit', name, options);
  }
  
  this.input = function(type, name, options) {
    if (options == null) options = {};
    this.out({type: type, name: name, placeholder: options.placeholder, value: options.value});
  }
  
}

Mouse = function() {
  
  this.click = function(x, y, delay) {
    x = Math.floor(x)
    y = Math.floor(y)
    
    mouseClick(x, y, delay)
  }
  
  this.over = function(x, y, delay) {
    x = Math.floor(x)
    y = Math.floor(y)
    
    mouseOver(x, y, delay)
  }
  
  this.line = function(val, x1, x2) {
    return linearlyInterpolate(0, x1, 21, x2, val);
  }
  
  var linearlyInterpolate = function(x1, y1, x2, y2, t) {
    var m = (y2 - y1) / (x2 - x1);
    var b = y1 - m * x1
    return m * t + b;
  }
  
}

Keyboard = function() {
  
  this.press = function(key) {
    keyboardPress(key);
  }
  
}

Player = function(selector) {
  var self = this;
  var mouse = new Mouse();
  var keyboard = new Keyboard();
  
  this.isFullscreen = document.isFullscreen == true;
  this.actions = {}
  this.buttons = {}
  this.lines = {}
  
  this.init = function() {
    if (self.isFullscreen) {
      self.left = 0
      self.top = 0
      self.width = screen.width - 1
      self.height = screen.height - 1

    } else {
      var elem = $(selector)
      
      if (elem.length == 0) {
        self.error = true
        throw 'element not found: ' + selector
        return
      }
      
      // window.scrollTo(elem);
      
      var elemOffset = elem.offset()
      var elemHeight = elem.height()
      var elemWidth  = elem.width()
      
      // TODO remove the hardcoded height of the toolbars
      self.top = window.screenY + 87 + elemOffset.top
      self.left = window.screenX + elemOffset.left
      self.height = elemHeight
      self.width = elemWidth
    }
    
    self.bottom = self.top + self.height
    self.right = self.left + self.width
  }
  
  this.play = function() {
    this.clickButton('play');
  }
  
  this.fullscreenOn = function() {
    this.clickButton('fullscreen-on');
  }
  
  this.fullscreenOff = function() {
    this.clickButton('fullscreen-off');
  }
  
  this.seek = function(num) {
    this.clickLine('seek', num)
  }
  
  this.toggleFullscreen = function() {
    if (this.isFullscreen)
      this.fullscreenOff();
    else
      this.fullscreenOn();
  }
  
  this.clickLine = function(name, t) {
    var line = this.lines[name]
    if (line == null)
      throw "no line named " + name;
    
    var x;
    var y;
    
    if (line.x) {
      x = line.x
      y = mouse.line(t, line.y1, line.y2);
      
    } else {
      x = mouse.line(t, line.x1, line.x2)
      y = line.y;
    }
    
    mouse.click(x, y, line.delay);
  }
  
  this.clickButton = function(name) {
    var button = this.buttons[name];
    if (button == null)
      throw "no button named " + name;
    
    if (button.key) {
      keyboard.press(button.key)
    } else {
      mouse.click(button.x, button.y, button.delay)
    }
    
    if (button.callback) button.callback()
  }
  
  this.overButton = function(name) {
    var button = this.buttons[name]
    if (button == null)
      throw "no button named " + name;
    mouse.over(button.x, button.y)
  }
  
  /**
   * Setting up the player
   */
  
  this.setPlay = function(options) {
    this.addButton('play', options)
  }
  
  this.setFullscreenOff = function(options) {
    options.callback = function() { fullscreen(false) }
    this.addButton('fullscreen-off', options)
  }
  
  this.setFullscreenOn = function(options) {
    options.callback = function() { fullscreen(true) }
    this.addButton('fullscreen-on', options)
  }
  
  this.setSeek = function(options) {
    this.addLine('seek', options)
  }
  
  this.setBox = function(options) {
    this.box = {};
    
    switch(options.width) {
      case 'full':
        this.box.width = this.width
        break
      default:
        this.box.width = options.width
    }
    
    switch(options.align) {
      case 'middle':
        this.box.left = this.left + this.width/2 - this.box.width/2
        break

      default:
        this.box.left = this.left
        break
    }

    switch(options.height) {
      default:
        this.box.height = options.height
        break
    }
    
    switch(options.valign) {
      default:
        this.box.top = this.top + this.height - this.box.height
        break
    }
    
    this.box.bottom = this.box.top + this.box.height
    this.box.right = this.box.left + this.box.width
  }
  
  this.addButton = function(name, options) {
    var button = {delay: options.delay, callback: options.callback}
    
    if (options.key) {
      button.key = options.key;
    } else {
      button.x = alignX(options.align, options.x)
      button.y = alignY(options.valign, options.y)
    }
    
    this.buttons[name] = button
    this.actions[name] = function() { self.clickButton(name) }
  }
  
  this.addLine = function(name, options) {
    var line = {delay: options.delay}
    
    if (typeof options.x  == "number") line.x  = alignX(options.align, options.x)
    if (typeof options.x1 == "number") line.x1 = alignX(options.align, options.x1)
    if (typeof options.x2 == "number") line.x2 = alignX(options.align, options.x2)
    
    if (typeof options.y  == "number") line.y  = alignY(options.valign, options.y)
    if (typeof options.y1 == "number") line.y1 = alignY(options.valign, options.y1)
    if (typeof options.y2 == "number") line.y2 = alignY(options.valign, options.y2)
    
    this.lines[name] = line;
  }
  
  var alignX = function(align, x) {
    
    switch(align) {
      case 'right':
        return self.box.right - x
        
      case 'middle':
        return self.box.left + self.box.width / 2;
        
      default:
        return self.box.left + x
    }
    
  }
  
  var alignY = function(align, y) {
    
    switch(align) {
      case 'bottom':
        return self.box.bottom - y
        
      default:
        return self.box.top + y
    }
    
  }
  
  this.init();
  
}