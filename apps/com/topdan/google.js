//
// @import lib/all
// @url    http://www.google.com
//

route("/", "index", function() {
  action("doSearch");
});

route("/search", "search", function() {
  action("doNext");
});

function index() {
  toolbar("Google");
  br();
  br();
  
  form('doSearch', function(f) {
    
    f.fieldset(function() {
      f.search('q', {placeholder: 'Google Search'});
    })
    f.br();
    f.br();
    f.submit('Google Search');
  });
}

function doSearch(request) {
  document.location.href = 'http://www.google.com/search?q=' + encodeURIComponent(request.params.q) + '&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a';
  wait();
}

function search() {
  toolbar("Google");
  
  var results = [];
  $('#rso h3 a').each(function() {
    results.push({
      url: $(this).attr('href'),
      title: $(this).text()
    })
  });
  
  list(results);
}

function doNext() {
  // follow the next page link
  // go back to search
}
