//
// @import lib/all
// @url    http://movies.netflix.com
//
this.header = "Netflix"

route("/WiHome", "index", function() {
  action("doSearch");
});

route("/WiSearch", "search", function() {
  action("doSearch");
})

route('/Queue', 'instantQueue', function() {
  action("doSearch");
})

route(/^\/WiMovie/, 'movie');

function index(request) {
  searchForm();
  
  list([
    { title: "My Instant Queue",
      url: "http://movies.netflix.com/Queue?qtype=ED"
    },
    { title: "New Arrivals",
      url: "http://movies.netflix.com/WiRecentAdditions"
    },
    { title: "Suggestions for You",
      url: "http://movies.netflix.com/RecommendationsHome"
    },
  ])
}

function searchForm() {
  var value = $('#searchField').val();
  if (value == "Movies, TV shows, actors, directors, genres") value = "";
  
  form('doSearch', function(f) {
    
    f.br();
    f.fieldset(function() {
      f.search('q', {placeholder: 'Netflix Search', value: value});
    })
    
  });
}

function doSearch(request) {
  $('#searchField').val(request.params.q);
  $('#global-search').submit();
  wait();
}

function search(request) {
  searchForm();
  
  var results = [];
  $('#searchResultsPrimary .mresult').each(function() {
    var e = $(this);
    results.push({
      title: e.find('.mdpLink').text(),
      url:   externalURL(e.find('.mdpLink').attr('href')),
      image: externalURL(e.find('img').attr('src'))
    });
  });
  list(results);
  
  paginate([
    {name: 'prev', url: $('.prev').attr('href')},
    {name: 'next', url: $('.next').attr('href')},
  ])
}

function instantQueue(request) {
  title("Recently Watched");
  var results = [];
  $('#athome tbody tr').each(function() {
    var e = $(this);
    results.push({
      title: e.find('.title a').text(),
      url:   externalURL(e.find('.title a').attr('href'))
    });
  });
  list(results);
  
  
  title("Instant Queue");
  var results = [];
  $('#queue tbody tr').each(function() {
    var e = $(this);
    results.push({
      title: e.find('.title a').text(),
      url:   externalURL(e.find('.title a').attr('href'))
    });
  });
  list(results);
  
}

function movie(request) {
  $('#sdp-actions a').each(function() {
    br();
    button($(this).find('span').text(), externalURL($(this).attr('href')));
  })
}
