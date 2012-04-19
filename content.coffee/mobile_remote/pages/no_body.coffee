class NoBody
  MobileRemote.Pages.NoBody = NoBody
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    if request.isScript
      "// no body";
    else
      @remote.views (v) ->
        v.page 'no_body', ->
          v.toolbar();
          v.title("Invalid Page");
          
          v.error("Internal Error: That page didn't contain anything.");
    