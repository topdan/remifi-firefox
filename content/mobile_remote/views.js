MobileRemote.Views = function(env) {
  
  this.content = [];
  
  this.html = function() {
    return this.content.join("");
  }
  
  this.template = function(path, data) {
    content = env.fileContent(path);
    func = MobileRemote.microtemplate(content);
    var html = data ? func(data) : func();
    this.content.push(html);
  }
  
  this.page = function(id, callback) {
    this.content.push('<div id="' + id + '">');
    callback();
    this.content.push('</div>');
  }
  
  this.toolbar = function(name, options) {
    if (options == null) options = {};
    var left = options.left;
    var right = options.right;
    
    this.template('/views/toolbar.html', {name: name, left: left, right: right});
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