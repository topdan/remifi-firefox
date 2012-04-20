@HTTP = {}

@HTTP.get = (url) ->
  crossDomainGet(url)
