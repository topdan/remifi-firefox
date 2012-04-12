if (MobileRemote.Views == null) MobileRemote.Views = {}

MobileRemote.Views.Base = function(env) {
  
  this.out = [];
  
  this.html = function() {
    return this.out.join("");
  }
  
  this.safeOut = function(s) {
    this.out.push(s);
  }
  
  this.template = function(path, data) {
    if (data == null) data = {};
    data.escape = this.escape;
    data.escapeHTML = this.escapeHTML;
    
    var code = env.fileContent(path);
    if (code == null)
      throw "viewpath not found: " + path;
    
    var func = MobileRemote.microtemplate(code);
    var html = func(data);
    
    this.out.push(html);
    
    return html;
  }
  
  this.escape = function(string) {
    return MobileRemote.escape(string);
  }
  
  this.escapeHTML = function(string) {
    return MobileRemote.escapeHTML(string);
  }
  
  this.page = function(id, callback) {
    this.out.push('<div id="' + id + '">');
    callback();
    this.out.push('</div>');
  }
  
  this.toolbar = function(options) {
    if (options == null) options = {};
    var right = options.right || {title: 'home', url: '/home.html'};
    return this.template('/views/toolbar.html', {back: options.back, stop: options.stop, right: right});
  }
  
  this.title = function(title) {
    this.out.push('<h1>' + this.escapeHTML(title) + '</h1>');
  }
  
  this.button = function(name, url, options) {
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
    this.out.push('<a class="' + this.escape(klass) + '" href="' + this.escape(url) + '" style="">' + this.escapeHTML(name) + '</a>')
  }
  
  this.br = function() {
    this.out.push("<br/>");
  }
  
  this.form = function(url, callback) {
    var form = new MobileRemote.Views.Form(this, env, url);
    callback(form);
    
    this.out.push(form.html());
  }
  
  this.error = function(message) {
    this.out.push('<p class="error-message">', this.escapeHTML(message), '</p>');
  }
  
  this.list = function(items, options) {
    if (options == null) options = {};
    if (items == null || items.length == 0) return;
    
    this.template("/views/list.html", {items: items, rounded: options.rounded});
  }
  
  this.apps = function(apps, options) {
    if (options == null) options = {}
    if (apps.length == 0) return

    var row = []
    var rows = [row];

    var count = 0;
    for (var i = 0 ; i < apps.length ; i++) {
      var app = apps[i];

      if (count == 4) {
        row = []
        rows.push(row)
        count = 0
      }

      if (app == null) {
        app = {isBlank: true, icon: {}};
        
      } else if (app.icon == null) {
        app.icon = {
          width: 60,
          height: 60,
          url: '/static/images/bhg.png'
        }
      } else if (app.icon == 'folder') {
        app.icon = {
          width: 60,
          height: 60,
          url: '/static/images/crystal_clear_icons/folder_grey_open.png'
        }
      }

      row.push(app)
      count++
    }

    while (row.length < 4) {
      row.push({isBlank: true})
    }

    this.template("/views/buttons.html", {rows: rows, tableId: options.tableId, tableClass: options.tableClass});
  }
  
  this.systemApps = function(apps, options) {
    if (options == null) options = {}
    options = MobileRemote.mergeHash(options, {tableClass: 'system-app-icons'})
    
    this.apps(apps, options)
  }
  
};