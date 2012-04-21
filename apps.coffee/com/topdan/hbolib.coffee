this.catalogURL = (path) -> throw "Must be implemented"
this.codes = -> throw "Must be implemented"

this.getXML = (path) ->
  if path.substring(0, 7) == "http://"
    url = path
  else
    url = @catalogURL(path)
  # throw url
  xml = HTTP.get(url)
  throw "Could not read URL: #{url}" if xml == null
  
  parser = new window.DOMParser()
  doc = parser.parseFromString(xml,"text/xml")
  $(doc)

this.findAnchor = (anchor) ->
  anchor = anchor.match(/[^\/]+/)
  anchor[0] if anchor

this.findCode = (anchor) ->
  anchor = this.findAnchor(anchor)

  code = null
  for key,value of @codes()
    code = key if anchor == value

  throw "unknown code for #{anchor}" if code == null
  code

this.findThumb = (e) ->
  thumb = null

  e.find('imageResponses').each () ->
    if $(this).find('mediaSubType').text() == "THUMB_MEDIUM"
      thumb = $(this).find("resourceUrl").text()
  thumb

this.urlForSomething = (code, e) ->
  typeCode = e.find('typeCode').text()

  if typeCode == "BUNDLE" || e.get(0).nodeName == 'bundleCategory'
    '/#' + codes()[code] + '/browse&assetID=' + e.find('TKey').text() + '?seriesID=' + e.find('categoryTkey').text() + '?assetType=SEASON?browseMode=browseGrid/'

  else if typeCode == "PACKAGE"
    '/#' + codes()[code] + '/browse&assetID=' + e.find('TKey').text() + '?assetType=PACKAGE?browseMode=browseGrid/'

  else if typeCode == "CATEGORY"
    '/#' + codes()[code] + '/browse&assetID=' + e.find('TKey').text() + '?assetType=SERIES?browseMode=browseGrid/'

  else if e.find('TKey').length > 0
    '/#' + codes()[code] + '/video&assetID=' + e.find('TKey').text() + '?videoMode=embeddedVideo?showSpecialFeatures=false/'
