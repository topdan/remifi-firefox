###
//
// @import lib/std
// @import com/topdan/hbolib
// @domain www.hbogo.com
// @crossdomain catalog.lv3.hbogo.com
//
###

route "/", "index"
route '/', "index", anchor: 'home/'
route '/', "section", anchor: /^[^\/]+\/$/
route '/', "category", anchor: /browseMode=browseGrid\?browseID=/
# route '/', 'video', anchor: /\/video&/
route '/', "notFound", anchor: /.*/

this.catalogURL = (path) ->
  'http://catalog.lv3.hbogo.com' + path

this.codes = ->
  {
    FC: 'preview',
    HO: 'home',
    MO: 'movies',
    SE: 'series',
    CO: 'comedy',
    ST: 'sports',
    DO: 'documentaries',
    LN: 'late%20night'
  }
  

this.index = (request) ->
  xml = getXML('/apps/mediacatalog/rest/navigationBarService/HBO/navigationBar/NO_PC')
  
  xml.find('navBarelementResponses').list (r) ->
    e = $(this)
    title = e.find('title').text()
    anchor = title.toLowerCase()
    anchor = 'preview' if anchor == 'free'
    return if anchor == 'home'
    
    r.title = title
    r.url   = '/#' + anchor + '/'
  
  sectionFeatured('HO')

this.section = (request) ->
  code = findCode(request.anchor)
  sectionCategories(code)
  sectionFeatured(code)

this.sectionCategories = (code) ->
  xml = getXML('/apps/mediacatalog/rest/quicklinkService/HBO/quicklink/' + code)
  
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
  xml = getXML('/apps/mediacatalog/rest/landingService/HBO/landing/' + code)
  
  xml.find('adminProxyContentResponse').list (r) ->
    e = $(this)
    
    r.title = e.find('title').text()
    r.url   = urlForSomething(code, e)
    r.image = findThumb(e)

this.category = (request) ->
  m = request.anchor.match(/browseID=([^\.]+).([^\.]+)$/)
  type = m[1] if m
  id = m[2] if m
  xml = null
  
  # not sure about a better way to detect this
  if id == "INDB464/"
    if request.anchor.indexOf('assetID=') == -1
      xml = getXML('/apps/mediacatalog/rest/categoryBrowseService/HBO/category/INDB464')
      seriesCategory(request, xml)
    else
      assetId = request.anchor.match(/assetID=([^\?]+)/)[1]
      xml = getXML("/apps/mediacatalog/rest/productBrowseService/HBO/category/" + assetId)
      seriesEpisodes(request, xml)
    
  else
    xml = getXML('/apps/mediacatalog/rest/productBrowseService/' + type + '/' + id)
    featureCategory(request, xml)

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
    r.url   = '/#' + code + '/video&assetID=' + e.find('TKey').text() + '?videoMode=embeddedVideo?showSpecialFeatures=false/'
    r.image = findThumb(e)
