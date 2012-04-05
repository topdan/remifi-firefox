this.pages = {};
// $ = jQuery;

function page(path, funcName, block) {
  var page = {path: path, funcName: funcName, actions: []};
  var context = {};
  
  this.currentPage = page;
  block.call(context);
  this.currentPage = null;
  
  this.pages[path] = page;
}

function action(name, funcName) {
  if (currentPage) {
    if (funcName == null) 
      funcName = name;
    currentPage.actions.push({name: name, funcName: funcName})
  }
}

function render(request) {
  var page = null;
  var action = null;
  
  $.each(this.pages, function(index, p) {
    if (request.path == p.path) 
      page = p;
  })
  
  if (page == null)
    return null;
  
  if (request.action) {
    $.each(page.actions, function(index, a) {
      if (request.action == a.name) 
        action = a;
    })
  }
  
  if (action)
    return this[action](request)
  else if (page)
    return this[page.funcName](request)
}