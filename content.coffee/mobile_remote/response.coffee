class Response
  MobileRemote.Response = Response
  
  constructor: ->
    @code = 200;
    @message = "OK";
    @headers = {};
  
  headersString: =>
    webpage = "HTTP/1.1 #{@code} #{@message}\r\n"
    for key,value of @headers
      webpage += "#{key}: #{value}\r\n"
    
    webpage += "\r\n"
    webpage
    