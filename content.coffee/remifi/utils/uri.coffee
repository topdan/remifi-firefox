class URI
  Remifi.URI = URI
  
  constructor: (@str) ->
    o = Remifi.parseUriOptions
    i = 14
    
    if o.parser[o.strictMode]
      m = 'strict'
    else
      m = 'loose'
    
    m = o.parser[m].exec(@str)
    
    this[o.key[i]] = m[i] || "" while (i--)
    
    this[o.q.name] = {};
    self = this
    this[o.key[12]].replace(o.q.parser, ($0, $1, $2) ->
      self[o.q.name][$1] = $2 if $1
    )
    
  toString: =>
    @str
  
  clone: =>
    Remifi.cloneHash(@)

Remifi.parseUriOptions = {
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


Remifi.addUriQuery = (url, params) ->
  unless params == null
    count = 0;
    count = 1 if url.indexOf("?") != -1
    
    for key in params
      val = params[key];
      
      unless val == null
        if count++ == 0
          url += "?";
        else
          url += "&";
        url += key + "=" + encodeURIComponent(val);
  
  url
