class Static
  MobileRemote.Static = Static
  
  constructor: (@remote, @filename) ->
    @timestamps = JSON.parse @remote.env.fileContent(@filename)
  
  urlFor: (filename) =>
    timestamp = @timestamps[filename]
    if timestamp
      "#{filename}?#{timestamp}"
    else
      filename