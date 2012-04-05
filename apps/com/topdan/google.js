//
// @import lib/all
// @url    http://www.google.com
//

page("/", "index", function() {
  action("doSearch");
});

page("/search", "search", function() {
  action("doNext");
});

function index() {
  return "index"
  // toolbar("Google");
  // br();
  // br();
  // 
  // form('doSearch', function(f) {
  //   
  //   f.fieldset(function() {
  //     f.search('q', {placeholder: 'Google Search'});
  //   })
  //   
  //   f.submit('Google Search');
  // });
}

function doSearch() {
  return "doSearch"
  // fill in the text field
  // press the appropriate button
}

function search() {
  return "search"
  // display the results
  // paginate
}

function doNext() {
  return "doNext"
  // follow the next page link
  // go back to search
}
