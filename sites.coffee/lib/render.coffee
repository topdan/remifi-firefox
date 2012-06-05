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
  @preventDefault()
  @waitOptions = options

this.performRender = (request, handler, name) ->
  if typeof handler == 'function'
    handler(request)
  else if name == 'action'
    throw "Action not found for #{request.action}"
  else
    throw "View not found for #{request.path}"

this.preventDefault = () ->
  this.isPreventDefault = true

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
    
    this.isPreventDefault = false
    if action
      if action.source
        source = this[action.source]
        throw "Action source not found #{action.source}" unless source
        source = source()
      else
        source = this
      
      performRender request, source[action.funcName], 'action'
    
    performRender request, this[route.funcName], 'view' unless this.isPreventDefault
    
  @request = null;
  
  if @waitOptions
    @pages = {type: 'wait', ms: @waitOptions.ms}
    @waitOptions = null
  
  variables(request.variables)
  
  JSON.stringify(@pages)
