// parseUri 1.2.2
// (c) Steven Levithan <stevenlevithan.com>
// MIT License

MobileRemote.URI = function(str) {
  var uri = this;
  var o = MobileRemote.parseUriOptions,
    m   = o.parser[o.strictMode ? "strict" : "loose"].exec(str),
    i   = 14;

  while (i--) this[o.key[i]] = m[i] || "";

  this[o.q.name] = {};
  this[o.key[12]].replace(o.q.parser, function ($0, $1, $2) {
    if ($1) uri[o.q.name][$1] = $2;
  });
  
  this.toString = function() {
    return str;
  }
  
  this.clone = function() {
    return MobileRemote.cloneHash(this);
  }
}

MobileRemote.parseUriOptions = {
  strictMode: false,
  key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],
  q:   {
    name:   "queryKey",
    parser: /(?:^|&)([^&=]*)=?([^&]*)/g
  },
  parser: {
    strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
    loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
  }
};


MobileRemote.addUriQuery = function(url, params) {
  if (params != null) {
    var count = 0;
    if (url.indexOf("?") != -1) count = 1;
    
    for (var key in params) {
      var val = params[key];
      
      if (val != null) {
        if (count++ == 0)
          url += "?";
        else
          url += "&";
        url += key + "=" + encodeURIComponent(val);
      }
    }
  }
  
  return url;
}
