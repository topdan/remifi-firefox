//
// @import lib/all
// @url    http://www.youtube.com
//
this.header = "YouTube"

route("/", "index", function() {
  action("doSearch");
});

route("/results", "results", function() {
  action("doSearch");
})

function index(request) {
  searchForm();
  
  var results = [];
  $('.feed-item-main').each(function() {
    var e = $(this);
    var link = e.find('h4 a');
    
    results.push({
      title: link.text(),
      url:   externalURL(link.attr('href')),
      image: externalURL(e.find('.feed-item-thumb img').attr('src'))
    });
  });
  
  list(results);
}

function results(request) {
  searchForm();
  
  var results = [];
  $('#search-results > div.result-item').each(function() {
    var e = $(this);
    var link = e.find('h3 a');
    
    results.push({
      title: link.text(),
      url:   externalURL(link.attr('href')),
      image: externalURL(e.find('.thumb-container img').attr('src'))
    });
  });
  
  list(results);
}

function searchForm() {
  form('doSearch', function(f) {
    
    f.br();
    f.fieldset(function() {
      f.search('q', {placeholder: 'YouTube Search', value: $('#masthead-search-term').val()});
    })
    f.br();
    
  });
}

function doSearch(request) {
  document.location.href = 'http://www.youtube.com/results?search_query=' + encodeURIComponent(request.params.q);
  wait();
}
