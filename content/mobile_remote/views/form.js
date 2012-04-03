if (MobileRemote.Views == null) MobileRemote.Views = {}

MobileRemote.Views.Form = function(env, url, options) {
  if (options == null) options = {};
  
  this.content = ['<form action="' + url + '" method="GET"><ul class="edit">'];
  
  this.html = function() {
    this.content.push('</ul></form>')
    return this.content.join("");
  }
  
  this.url = function(name, options) {
    this.input('url', name, options);
  }
  
  this.search = function(name, options) {
    this.input('search', name, options);
  }
  
  this.input = function(type, name, options) {
    if (options == null) options = {};
    
    var rest = "";
    if (options.placeholder)
      rest = rest + ' placeholder="' + options.placeholder + '"';
    if (options.value)
      rest = rest + ' value="' + options.value + '"';
    
    this.content.push('<li><input type="' + type + '" name="' + name + '"' + rest + '/></li>');
  }
  
}
