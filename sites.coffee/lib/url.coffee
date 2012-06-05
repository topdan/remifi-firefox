this.externalURL = (url) ->
  return null if @request == null || url == null || typeof url == "undefined"
  
  if @request.port == '' || @request.port == '80'
    host = @request.host
  else
    host = "#{@request.host}:#{@request.port}"
  
  # absolute url using same protocol
  if url.match(/^\/\//)
    @request.protocol + ":" + url
    
  # absolute path with same protocol and host
  else if url.match(/^\//)
    @request.protocol + "://" + host + url;
    
  # absolute url
  else if url.match(/^http:\/\//) || (url.match(/^https:\/\//))
    url
  
  # page anchor
  else if url.match(/^#/)
    @request.protocol + "://" + host + @request.path + url
    
  # relative url
  else
    i = @request.path.lastIndexOf('/');
    dir = @request.path.substring(0, i);
    @request.protocol + "://" + host + dir + '/' + url

class URI
  constructor: (@str) ->
    o = {
      strictMode: false,
      key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],
      q:   {
        name:   "params",
        parser: /(?:^|&)([^&=]*)=?([^&]*)/g
      },
      parser: {
        strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
        loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
      }
    }

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

this.URI = URI