@routes = []
@globalActions = []

this.route = (path, funcName, options, block) ->
  if typeof options == 'function'
    block = options
    options = {}
  else if options == null
    options = {}
  else
    options ||= {}
  
  route = {funcName: funcName, actions: [].concat(@globalActions)}
  
  if typeof path == "string"
    route.pathString = path
  else if typeof path == "object"
    route.pathRegex = path;
  
  route.anchor = options.anchor || null
  if typeof options.anchor == "string"
    route.anchorString = options.anchor
  else if typeof options.anchor == "object"
    route.anchorRegex = options.anchor;
  
  @currentRoute = route;
  context = {}
  block.call(context) if block
  @currentRoute = null
  
  @routes.push(route)

this.action = (name, funcName) ->
  funcName ||= name
  action = {name: name, funcName: funcName}
  if @currentRoute
    @currentRoute.actions.push(action)
  else
    @globalActions.push(action)

this.notFound = ->
  # do nothing

this.findRoute = (request) ->
  route = null;
  baseRoute = null;
  
  $.each @routes, (index, p) ->
    if p.anchor == null
      baseRoute ||= matchRoutePath(p, request)

    else if matchRouteAnchor(p, request)
      route ||= p
    
    null
  
  route || baseRoute

matchRoutePath = (route, request) ->
  if route.pathRegex && request.path.match(route.pathRegex)
    route
  else if route.pathString && request.path == route.pathString
    route
  else
    null

matchRouteAnchor = (route, request) ->
  if route.anchorRegex && request.anchor.match(route.anchorRegex)
    route
  else if route.anchorString && request.anchor == route.anchorString
    route
  else
    null
