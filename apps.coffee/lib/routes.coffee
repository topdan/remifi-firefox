@routes = []

@route = (path, funcName, options, block) ->
  if typeof options == 'function'
    block = options
    options = {}
  else if options == null
    options = {}
  
  route = {funcName: funcName, actions: []}
  
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

@action = (name, funcName) ->
  if currentRoute
    funcName ||= name
    currentRoute.actions.push({name: name, funcName: funcName})

@notFound = ->
  # do nothing

@findRoute = (request) ->
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
