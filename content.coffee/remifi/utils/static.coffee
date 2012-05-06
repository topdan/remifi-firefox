class Static
  Remifi.Static = Static
  
  constructor: (@remote, @filename) ->
    try
      @timestamps = JSON.parse @remote.env.fileContent(@filename)
  
  urlFor: (filename) =>
    return filename unless @timestamps
    
    timestamp = @timestamps[filename]
    if timestamp
      "#{filename}?#{timestamp}"
    else
      filename