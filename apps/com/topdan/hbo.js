//
// @import lib/all
// @url    http://www.hbogo.com
// @crossdomain catalog.lv3.hbogo.com
//

route("/", "index")
route('/', "index", {anchor: 'home/'})
route('/', "section", {anchor: /^[^\/]+\/$/})
route('/', "category", {anchor: /browseMode=browseGrid\?browseID=/})
route('/', 'video', {anchor: /\/video&/})
route('/', "notFound", {anchor: /.*/})

function video() {
  title("HBO video player not implemented")
  br()
  button('Use Mouse App', '/mouse/index.html', {type: 'primary'})
}

function index(request) {
  var xml = getXML('/apps/mediacatalog/rest/navigationBarService/HBO/navigationBar/NO_PC');
  
  xml.find('navBarelementResponses').list(function(r) {
    var e = $(this);
    var title = e.find('title').text();
    var anchor = title.toLowerCase();
    if (anchor == 'free') anchor = 'preview'
    if (anchor == 'home') return;
    
    r.title = title;
    r.url   = '/#' + anchor + '/';
  })
  
  sectionFeatured('HO');
}

function section(request) {
  var code = findCode(request.anchor);
  sectionCategories(code);
  sectionFeatured(code);
}

function sectionCategories(code) {
  var xml = getXML('/apps/mediacatalog/rest/quicklinkService/HBO/quicklink/' + code);
  
  xml.find('quicklinkElement,quicklinkElements').list(function(r) {
    var e = $(this);
    var url = e.find('uri').text();
    var m = url.match(/\/([^\/]+)\/([^\/]+)$/)
    var type = m ? m[1] : null;
    var id = m ? m[2] : null;
    
    if (e.find('quicklinkElements').length == 0) {
      r.title = e.find('displayName').text();
      r.url   = '/#' + request.anchor + 'browse&browseMode=browseGrid?browseID=' + type + '.' + id + '/'
    }
  })
}

function sectionFeatured(code) {
  var xml = getXML('/apps/mediacatalog/rest/landingService/HBO/landing/' + code);
  
  xml.find('adminProxyContentResponse').list(function(r) {
    var e = $(this);
    
    r.title = e.find('title').text();
    r.url   = urlForSomething(code, e);
    r.image = findThumb(e)
  })
}

function category(request) {
  var m = request.anchor.match(/browseID=([^\.]+).([^\.]+)$/)
  var type = m ? m[1] : null;
  var id = m ? m[2] : null;
  var xml = null;
  
  // not sure about a better way to detect this
  if (id == "INDB464/") {
    if (request.anchor.indexOf('assetID=') == -1) {
      xml = getXML('/apps/mediacatalog/rest/categoryBrowseService/HBO/category/INDB464');
      return seriesCategory(request, xml)
    } else {
      var assetId = request.anchor.match(/assetID=([^\?]+)/)[1]
      xml = getXML("/apps/mediacatalog/rest/productBrowseService/HBO/category/" + assetId)
      return seriesEpisodes(request, xml)
    }
  } else {
    xml = getXML('/apps/mediacatalog/rest/productBrowseService/' + type + '/' + id);
    return featureCategory(request, xml)
  }
}

function urlForSomething(code, e) {
  var typeCode = e.find('typeCode').text();
  
  if (typeCode == "ASSET") {
    return '/#' + code + '/video&assetID=' + e.find('TKey').text() + '?videoMode=embeddedVideo?showSpecialFeatures=false/'
    
  } else if (typeCode == "BUNDLE") {
    return '/#' + code + '/browse&assetID=' + e.find('TKey').text() + '?seriesID=' + e.find('categoryTkey').text() + '?assetType=SEASON?browseMode=browseGrid/'
    
  } else if (typeCode == "PACKAGE") {
    return '/#' + code + '/browse&assetID=' + e.find('TKey').text() + '?assetType=PACKAGE?browseMode=browseGrid/'
    
  } else {
    return '/';
  }
}

function seriesEpisodes(request, xml) {
  var code = request.anchor.match(/([^\/]+)/)[1]
  xml.find('featureResponses').list(function(r) {
    var e = $(this);
    
    r.title    = e.find('title').text();
    r.episode  = parseInt(e.find('episodeInSeries').text());
    r.subtitle = e.find('season').text() + " Episode " + e.find('episodeInSeason').text();
    
    r.url = urlForSomething(code, e);
    r.image = findThumb(e);
  }, {sort: function(a, b) { return a.episode - b.episode }})
}

function seriesCategory(request, xml) {
  var code = request.anchor.match(/([^\/]+)/)[1]
  xml.find('bundleCategory').list(function(r) {
    var e = $(this);
    
    r.title = e.find('title').text();
    r.url   = '/#' + code + '/browse&assetID=' + e.find('TKey').text() + '?assetType=SERIES?browseMode=browseGrid?browseID=category.INDB464/';
    r.image = findThumb(e);
  })
}

function featureCategory(request, xml) {
  var code = request.anchor.match(/([^\/]+)/)[1]
  xml.find('featureResponse').list(function(r) {
    var e = $(this);
    
    r.title = e.find('title').text();
    r.url   = '/#' + code + '/video&assetID=' + e.find('TKey').text() + '?videoMode=embeddedVideo?showSpecialFeatures=false/';
    r.image = findThumb(e);
  })
}

function findCode(anchor) {
  var codes = {
    FC: 'preview',
    HO: 'home',
    MO: 'movies',
    SE: 'series',
    CO: 'comedy',
    ST: 'sports',
    DO: 'documentaries',
    LN: 'late%20night'
  }
  
  anchor = anchor.match(/[^\/]+/)
  
  var code = null;
  for (var key in codes) {
    if (anchor == codes[key])
      code = key;
  }
  
  if (code == null) throw "unknown code for " + anchor;
  
  return code;
}

function findThumb(e) {
  var thumb = null;
  
  e.find('imageResponses').each(function() {
    if ($(this).find('mediaSubType').text() == "THUMB_MEDIUM") {
      thumb = $(this).find("resourceUrl").text()
    }
  })
  
  return thumb;
}

function getXML(path) {
  var url = 'http://catalog.lv3.hbogo.com' + path;
  var xml = HTTP.get(url)
  if (xml == null) throw "Could not read URL: " + url
  
  var parser = new window.DOMParser();
  var doc = parser.parseFromString(xml,"text/xml");
  return $(doc)
}
