class Settings
  MobileRemote.Pages.Settings = Settings
  
  constructor: (@remote) ->
    @remote.version = @remote.env.fileContent('/content/VERSION');
    @xpiPath = "http://mobile-remote.topdan.com.s3.amazonaws.com/mobile-remote-edge.xpi";
  
  render: (request, response) =>
    if request.path == '/settings/index.html' || request.path == '/settings/'
      @index(request, response);
      
    else if request.path == '/settings/about.html'
      @about(request, response);
      
    else if request.path == '/settings/update.html'
      @update(request, response);
      
    else if request.path == '/settings/fullscreen.html'
      @fullscreen(request, response);
  
  index: (request, response) =>
    @remote.views (v) ->
      v.page 'settings', ->
        v.toolbar();
        v.title("Settings");
        v.list([
          {
            title: "Bookmarklets",
            url: "/bookmarklets/"
          },
          {
            title: "About Me",
            url: "/settings/about.html"
          }
        ])

        v.toggle 'Fullscreen Mode', '/settings/fullscreen.html', window.fullScreen
        v.button('Check for Updates', '/settings/update.html', {type: 'info'})

  fullscreen: (request, response) =>
    window.fullScreen = !window.fullScreen;
    @index(request, response);

  update: (request, response) =>
    remote = @remote
    @remote.views (v) ->
      v.page 'update', ->
        v.toolbar();
        v.title("System Update");

        request = new XMLHttpRequest();
        request.open('GET', 'http://mobile-remote.topdan.com/EDGE-VERSION', false);
        request.send(null);

        if request.status != 200
          v.error("Could not talk to the update server. Please try again later")

        else if request.responseText == remote.version
          v.info("You have the most up-to-date version of the mobile remote");
          v.br();
          v.button("Back to Settings", '/settings/index.html', {type: 'primary'});

        else
          v.info("There is an updated version of the mobile remote. Use the mouse app to agree to install the new version when the download is finished.");
          v.br();
          v.button("Get the Update", '/controls/visit.html?url=' + encodeURIComponent(@xpiPath), {type: "primary"})

  about: (request, response) =>
    @remote.views (v) ->
      v.page 'about_me', ->
        v.toolbar();
        v.title("About Me");

        v.list([
          {
            title: "Created By Dan Cunning"
          },
          {
            title: "Follow @itopdan",
            url: "http://www.twitter.com/itopdan"
          },
          {
            title: "Version: 0.1"
          }
        ])
