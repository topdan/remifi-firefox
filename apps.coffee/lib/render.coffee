@beforeFilters = []
@waitOptions = null

this.beforeFilter = (funcName) ->
  @beforeFilters.push(funcName)

runBeforeFilters = (request) ->
  self = @
  $.each this.beforeFilters, (index, filterName) ->
    func = self[filterName];
    throw "filter not found: " + filterName if func == null || typeof func == 'undefined'
    func.call self, request

this.isPerformed = ->
  @pages != null && typeof @pages != 'undefined' && @pages.content.length != 0

this.wait = (options) ->
  options ||= {}
  @waitOptions = options

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
    
    handler = null
    if action
      handler = this[action.funcName]
    else
      handler = this[route.funcName]
      
    if typeof handler == 'function'
      handler(request)
    else
      throw "View not found for " + request.path
  
  @request = null;
  
  if @waitOptions
    @pages = {type: 'wait', ms: @waitOptions.ms}
    @waitOptions = null
  
  JSON.stringify(@pages)
