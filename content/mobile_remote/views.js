MobileRemote.Views = function(env) {
  
  this.template = function(path, data) {
    content = env.fileContent(path);
    func = MobileRemote.microtemplate(content);
    return data ? func(data) : func();
  }
  
  this.page = function(id, content) {
    return '<div id="' + id + '">' + content + '</div>';
  }
  
  this.buttons = function(apps, options) {
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

    return this.template("/views/buttons.html", {rows: rows, tableId: options.tableId})
  }
  
};