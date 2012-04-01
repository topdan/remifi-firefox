MobileRemote.Views = function(env) {
  
  this.content = [];
  
  this.html = function() {
    return this.content.join("");
  }
  
  this.template = function(path, data) {
    content = env.fileContent(path);
    func = MobileRemote.microtemplate(content);
    return data ? func(data) : func();
  }
  
  this.page = function(id, callback) {
    this.content.push('<div id="' + id + '">');
    callback();
    this.content.push('</div>');
  }
  
  this.toolbar = function(name) {
    this.content.push('<div class="toolbar"><h1>' + name + '</h1></div>');
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

    var html = this.template("/views/buttons.html", {rows: rows, tableId: options.tableId, tableClass: options.tableClass});
    this.content.push(html);
  }
  
  this.systemApps = function(apps, options) {
    if (options == null) options = {}
    options = MobileRemote.mergeHash(options, {tableClass: 'system-app-icons'})
    
    this.apps(apps, options)
  }
  
};