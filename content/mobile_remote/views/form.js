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
  
  this.url = function(name, options) {
    this.input('url', name, options);
  }
  
  this.search = function(name, options) {
    this.input('search', name, options);
  }
  
  this.buttons = function(klass, callback) {
    this.content.push('<div class="buttons ' + klass + '">')
    callback();
    this.content.push('</div>');
  }
  
  this.submit = function(name, options) {
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
    this.content.push('<button class="' + klass + '">' + name + '</button>');
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
