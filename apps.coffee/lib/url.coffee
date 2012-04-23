this.externalURL = (url) ->
  return null if @request == null || url == null || typeof url == "undefined"
  
  # absolute url using same protocol
  if url.match(/^\/\//)
    @request.protocol + ":" + url
    
  # absolute path with same protocol and host
  else if url.match(/^\//)
    @request.protocol + "://" + @request.host + url;
    
  # absolute url
  else if url.match(/^http:\/\//) || (url.match(/^https:\/\//))
    url
    
  # relative url
  else
    i = @request.path.lastIndexOf('/');
    dir = @request.path.substring(0, i);
    @request.protocol + "://" + @request.host + dir + '/' + url
