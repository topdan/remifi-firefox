###
//
// @import lib/std
// @domain grooveshark.com
//
###

beforeFilter 'readHashbang'

action 'doSearch'
action 'playPause'
action 'prevSong'
action 'nextSong'
action 'index'
action 'clearQueue'
action 'removeCurrentSong'
action 'queueSong'

route '/', 'index'
  
route '/', 'search', anchor: /^!\/search/

route '/', 'album', anchor: /^!\/album/, ->
  action 'queueAlbum'

route '/', 'artist', anchor: /^!\/artist/, ->
  action 'playTopSongs'

this.artist = (request) ->
  controls()
  
  list [
    { 
      title: $('#page_content_profile_title').text(),
      image: $('#profileImage img').attr('src')
    }
  ]
  
  songDigest()

# TODO security warning and confirmation of "trusted" site
Grooveshark = window.wrappedJSObject.Grooveshark

this.index = (request) ->
  controls(true)
  
  current = Grooveshark.getCurrentSongStatus().song
  songs = []
  
  if current
    songs.push {
      title: current.artistName,
      image: current.artURL
      subtitle: current.songName,
      url: 'playPause.js'
    }
    list songs, internalURL: true
    
    list [{
      title: "Visit #{current.artistName}",
      url: externalURL("/#!/artist/#{encodeURIComponent(current.artistName)}/#{current.artistID}")
    },
    {
      title: "Visit #{current.albumName}",
      url: externalURL("/#!/artist/#{encodeURIComponent(current.albumName)}/#{current.albumID}")
    }]
    
  searchForm()
  
  br()
  
  unless Grooveshark.getCurrentSongStatus().status == 'none'
    button 'Remove Current Song', 'removeCurrentSong.js'
  
  button 'Clear Queue', 'clearQueue.js', type: 'danger'

this.album = (request) ->
  controls()
  
  list [
    { 
      title: $('#page_content_profile_title').text(), 
      image: $('#profileImage img').attr('src'), 
      subtitle: $('#page_content_synopsis .byline a').text()
    }
  ]
  
  button "Add Album", "queueAlbum.js?id=#{pageId}"
  
  title 'Songs'
  songDigest()

this.search = (request) ->
  controls()
  
  searchForm()
  
  title 'Artists'
  artistDigest()
  
  title 'Albums'
  albumDigest()
  
  title 'Songs'
  songDigest()

this.pageId = ->
  hashbang.path.match(/\/([^\/]+)$/)[1]

this.songDigest = ->
  $('.gs_grid').each ->
    name = $(this).find('.slick-column-name').attr('data-translate-text')
    if name == 'SONG' || name == "TRACK"
      $(this).find('.slick-row').list (r) ->
        # return if $(this).hasClass('slick-row-last')
        
        r.title    = $(this).find('.songName a')
        r.subtitle = $(this).find('.artist')
        r.url = "queueSong.js?id=#{r.title.attr('rel')}"
      , internalURL: true

this.albumDigest = ->
  $('#albumDigest li').list (r) ->
    r.title = $(this).find('.meta .name')
    r.url = $(this).find('.meta a')
    r.subtitle = $(this).find('.by')
    r.image = $(this).find('img')

this.artistDigest = ->
  $('#artistDigest li').list (r) ->
    r.title = $(this).find('.meta .name')
    r.url = $(this).find('.meta a')
    r.subtitle = $(this).find('.by')
    r.image = $(this).find('img')

this.controls = (onHome) ->
  if onHome
    item = {name: 'back', url: '/'}
  else
    item = {name: 'home', url: 'index'}
  
  paginate [
    {name: "prev", url: 'prevSong.js'},
    {name: "play", url: 'playPause.js'},
    item,
    {name: "next", url: 'nextSong.js'},
  ]

this.playPause = (request) ->
  # this method has trouble on the first song added to the queue
  # Grooveshark.togglePlayPause()
  
  status = Grooveshark.getCurrentSongStatus().status
  if status == 'loading' || status == 'playing' || status == 'buffering'
    Grooveshark.pause()
  else
    Grooveshark.play()

this.prevSong = (request) ->
  Grooveshark.previous()

this.nextSong = (request) ->
  Grooveshark.next()

this.queueSong = (request) ->
  if Grooveshark.getCurrentSongStatus().status == 'none'
    playAfter = true
    
  Grooveshark.addSongsByID(request.params.id)

this.queueAlbum = (request) ->
  Grooveshark.addAlbumByID(request.params.id)

this.clearQueue = (request) ->
  clickOn $('#queue_clear_button')

this.removeCurrentSong = (request) ->
  Grooveshark.removeCurrentSongFromQueue()

this.searchForm = ->
  @hashbang.params.q = decodeURIComponent(@hashbang.params.q) if @hashbang.params.q
  
  form 'doSearch', (f) ->
    f.fieldset ->
      f.search('q', {placeholder: 'Grooveshark Search', value: $('#header_search input').val() || @hashbang.params['q']})

this.doSearch = (request) ->
  document.location.href = externalURL("/#!/search?q=#{request.params.q}")
  wait ms: 3000

this.readHashbang = (request) ->
  if request.anchor && request.anchor.match(/^!/)
    this.hashbang = new URI(request.anchor.substring(1))
  else
    this.hashbang = new URI("")