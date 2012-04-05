if (MobileRemote.Views == null) MobileRemote.Views = {}

MobileRemote.Views.Form = function(view, env, url, options) {
  if (options == null) options = {};
  
  var inFieldSet = null;
  this.content = ['<form action="' + url + '" method="GET">'];
  
  this.html = function() {
    this.content.push('</ul></form>')
    return this.content.join("");
  }
  
  this.fieldset = function(callback) {
    this.content.push('<ul class="edit">')
    inFieldSet = true;
    callback();
    inFieldSet = false;
    this.content.push('</ul>')
  }
  
  this.br = function() {
    this.content.push("<br/>")
  }
  
  this.url = function(name, options) {
    this.input('url', name, options);
  }
  
  this.search = function(name, options) {
    this.input('search', name, options);
  }
  
  this.submit = function(name, url, options) {
    if (options == null) options = {};
    
    var klass = null;
    if (options.type == "info") {
      klass = "white";
      
    } else if (options.type == "danger") {
      klass = "redButton";
      
    } else if (options.type == "primary") {
      klass = "greenButton";
      
    } else {
      klass = "grayButton";
    }
    this.content.push('<a class="submit ' + klass + '" href="' + url + '" style="">' + name + '</a>')
  }
  
  this.input = function(type, name, options) {
    if (options == null) options = {};
    
    var rest = "";
    if (options.placeholder)
      rest = rest + ' placeholder="' + options.placeholder + '"';
    if (options.value)
      rest = rest + ' value="' + options.value + '"';
    
    var content = '<input type="' + type + '" name="' + name + '"' + rest + '/>';
    if (inFieldSet)
      content = '<li>' + content + '</li>'
    this.content.push(content);
  }
  
}
