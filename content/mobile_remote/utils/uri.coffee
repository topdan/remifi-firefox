class URI
  MobileRemote.URI = URI
  
  constructor: (@str) ->
    o = MobileRemote.parseUriOptions
    i = 14
    
    if o.parser[o.strictMode]
      m = 'strict'
    else
      m = 'loose'
    
    m = o.parser[m].exec(@str)
    
    this[o.key[i]] = m[i] || "" while (i--)
    
    this[o.q.name] = {};
    this[o.key[12]].replace(o.q.parser, ($0, $1, $2) ->
      uri[o.q.name][$1] = $2 if $1
    )
    
  toString: =>
    @str
  
  clone: =>
    MobileRemote.cloneHash(@)

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


MobileRemote.addUriQuery = (url, params) ->
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
