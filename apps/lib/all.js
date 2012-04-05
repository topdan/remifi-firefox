this.routes = {};

function route(path, funcName, block) {
  var route = {path: path, funcName: funcName, actions: []};
  var context = {};
  
  this.currentRoute = route;
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
  
  if (typeof handler == 'function')
    handler(request);
  else
    throw "Function not found: " + action.funcName || route.funcName;
  
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
  }
}

function page(id, callback) {
  this.pages.content.push({type: 'page', id: id, content: []})
  callback();
}

function currentPage() {
  ensurePage();
  return this.pages.content[this.pages.content.length - 1].content;
}

function toolbar(name) {
  currentPage().push({type: 'toolbar', name: name});
}

function br() {
  currentPage().push({type: 'br'});
}

function button(name, url, options) {
  currentPage().push({type: 'button', name: name, url: url, buttonType: options.type});
}

function error(message) {
  currentPage().push({type: 'error', text: message});
}

function list(items, options) {
  if (options == null) options = {};
  currentPage().push({type: 'list', items: items, rounded: options.rounded});
}

function form(action, callback) {
  var form = new Form();
  callback(form);
  currentPage().push({type: 'form', action: action, content: form.toArray()});
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

