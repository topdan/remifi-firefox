class NotFound
  Remifi.Pages.NotFound = NotFound
  
  constructor: (@remote) ->
  
  render: (request, response) =>
    @remote.views (v) ->
      v.page 'not_found', ->
        v.toolbar();
        v.title("Page Not Found");

        v.error("Sorry, that page was not found.");
    