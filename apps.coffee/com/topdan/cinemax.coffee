###
//
// @import lib/std
// @import com/topdan/hbolib
// @domain www.maxgo.com
// @crossdomain catalog.lv3.maxgo.com
//
###

# http://www.maxgo.com/#AD/browse&assetID=MUGOROSTP31043?assetType=SERIES?browseMode=browseGrid/

route "/", "index"
route '/', "index", anchor: 'movies/'
route '/', "section", anchor: /^[^\/]+\/$/
route '/', "category", anchor: /browseMode=browseGrid\?browseID=/
route '/', "notFound", anchor: /.*/

this.catalogURL = (path) ->
  'http://catalog.lv3.maxgo.com' + path

this.codes = ->
  {
    MO: 'movies',
    AD: 'after%20dark'
  }

this.index = (request) ->
  list([
    {title: "After Dark", url: externalURL("/#after dark/")}
  ])
  
  section(request)

this.section = (request) ->
  code = findCode(request.anchor)
  sectionCategories(code)
  sectionFeatured(code)

this.sectionCategories = (code) ->
  xml = getXML('/apps/mediacatalog/rest/quicklinkService/MAX/quicklink/' + code)

  xml.find('quicklinkElement,quicklinkElements').list (r) ->
    e = $(this)
    url = e.find('uri').text()
    m = url.match(/\/([^\/]+)\/([^\/]+)$/)
    type = m[1] if m
    id = m[2] if m

    if e.find('quicklinkElements').length == 0
      r.title = e.find('displayName').text()
      r.url   = '/#' + request.anchor + 'browse&browseMode=browseGrid?browseID=' + type + '.' + id + '/'

this.sectionFeatured = (code) ->
  xml = getXML('/apps/mediacatalog/rest/landingService/MAX/landing/' + code)

  xml.find('adminProxyContentResponse').list (r) ->
    e = $(this)
    
    r.title = e.find('title').text()
    r.url   = urlForSomething(code, e)
    r.image = findThumb(e)

this.category = (request) ->
  m = request.anchor.match(/browseID=([^\.]+).([^\.]+)\/$/)
  type = m[1] if m
  id = m[2] if m
  
  code = findCode(request.anchor)
  xml = getXML('/apps/mediacatalog/rest/quicklinkService/MAX/quicklink/' + code)
  
  categoryURL = null
  xml.find('quicklinkElement,quicklinkElements').each ->
    uri = $(this).find('uri').text()
    categoryURL = uri if uri && uri.match("#{type}/#{id}$")
  
  return unless categoryURL
  xml = getXML categoryURL
  
  if xml.find('featureResponses').length > 0
    seriesEpisodes(request, xml)
    
  else if xml.find('productResponses').length > 0
    featureCategory(request, xml)
    
  else if xml.find('bundleCategory').length > 0
    seriesCategory(request, xml)
    
  else
    throw "unknown category: #{catgoryURL}"

this.seriesEpisodes = (request, xml) ->
  code = request.anchor.match(/([^\/]+)/)[1]
  xml.find('featureResponses').list (r) ->
    e = $(this)

    r.title    = e.find('title').text()
    r.episode  = parseInt(e.find('episodeInSeries').text())
    r.subtitle = e.find('season').text() + " Episode " + e.find('episodeInSeason').text()

    r.url = urlForSomething(code, e)
    r.image = findThumb(e)
  , sort: (a, b) -> a.episode - b.episode

this.seriesCategory = (request, xml) ->
  code = request.anchor.match(/([^\/]+)/)[1]
  xml.find('bundleCategory').list (r) ->
    e = $(this)

    r.title = e.find('title').text()
    r.url   = '/#' + code + '/browse&assetID=' + e.find('TKey').text() + '?assetType=SERIES?browseMode=browseGrid?browseID=category.INDB464/'
    r.image = findThumb(e)

this.featureCategory = (request, xml) ->
  code = request.anchor.match(/([^\/]+)/)[1]
  xml.find('featureResponse').list (r) ->
    e = $(this)

    r.title = e.find('title').text()
    r.url   = urlForSomething(code, e)
    r.image = findThumb(e)
