class Response
  MobileRemote.Response = Response
  
  constructor: ->
    @code = 200;
    @message = "OK";
    @headers = {};
  
  headersString: ->
    webpage = "HTTP/1.1 #{@code} #{@message}\r\n"
    for key in @headers
      webpage += key + "#{key}: #{@headers[key]}\r\n"
    
    webpage += "\r\n"
    webpage
    