if (MobileRemote.Pages == null) MobileRemote.Pages = {}

MobileRemote.Pages.Dashboard = function(remote) {
  
  this.getBody = function(request, response) {
    return remote.views.page('page1', remote.views.buttons([
      {
        title: "Page",
        url: "foo.html"
      },
      {
        title: "Tabs",
        url: "tabs.html"
      },
      {
        title: "Windows",
        url: "windows.html"
      },
      {
        title: "Bookmarks",
        url: "bookmarks.html"
      },
      {
        title: "History",
        url: "history.html"
      }
    ]));
  };
  
};
