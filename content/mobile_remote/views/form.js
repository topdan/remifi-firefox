if (MobileRemote.Views == null) MobileRemote.Views = {}

MobileRemote.Views.Form = function(view, env, url, options) {
  if (options == null) options = {};
  
  var inFieldSet = null;
  this.out = ['<form action="' + url + '" method="GET">'];
  
  this.html = function() {
    this.out.push('</ul></form>')
    return this.out.join("");
  }
  
  this.fieldset = function(callback) {
    this.out.push('<ul class="edit">')
    inFieldSet = true;
    callback();
    inFieldSet = false;
    this.out.push('</ul>')
  }
  
  this.br = function() {
    this.out.push("<br/>")
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
    this.out.push('<a class="submit ' + klass + '" href="' + url + '" style="">' + name + '</a>')
  }
  
  this.input = function(type, name, options) {
    if (options == null) options = {};
    
    var rest = "";
    if (options.placeholder)
      rest = rest + ' placeholder="' + options.placeholder + '"';
    if (options.value)
      rest = rest + ' value="' + options.value + '"';
    
    var code = '<input type="' + type + '" name="' + name + '"' + rest + '/>';
    if (inFieldSet)
      content = '<li>' + code + '</li>'
    this.out.push(code);
  }
  
}
