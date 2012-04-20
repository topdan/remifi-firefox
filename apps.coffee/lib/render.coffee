@beforeFilters = []
@isWaiting = false

this.beforeFilter = (funcName) ->
  @beforeFilters.push(funcName)

runBeforeFilters = (request) ->
  self = @
  $.each this.beforeFilters, (index, filterName) ->
    func = self[filterName];
    throw "filter not found: " + filterName if func == null

this.isPerformed = ->
  @pages.content.length != 0

this.wait = ->
  @isWaiting = true

this.render = (request) ->
  @request = request
  runBeforeFilters(request);
  
  unless isPerformed()
    route = findRoute(request);
    action = null;
    
    return null if route == null
    
    if request.action
      $.each route.actions, (index, a) ->
        action = a if request.action == a.name
    
    handler = null;
    if action
      handler = this[action.funcName]
    else
      handler = this[route.funcName]
      
    if typeof handler == 'function'
      handler(request)
    else
      throw "View not found for " + request.path
  
  @request = null;
  
  @pages = {type: 'wait'} if @isWaiting
  
  JSON.stringify(this.pages)
