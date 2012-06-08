###
//
// @import lib/std
// @domain www.justin.tv
// @domain justin.tv
// @domain www.twitch.tv
// @domain twitch.tv
// @home.title justin.tv
// @home.pos  16
// @home.url  http://www.justin.tv
// @home.img  justintv.png
//
###

beforeFilter 'ageButton'

action 'over18'
action 'doSearch'

route '/', 'index', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

route /^\/directory/, 'directory'
route '/search', 'search'

route //, 'tryVideo', ->
  action 'playPause', on: 'player'
  action 'toggleFullscreen', on: 'player'

this.index = (request) ->
  searchForm()
  
  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  list [
    {title: 'Producers', url: externalURL('/directory/featured') },
    {title: 'Mobile', url: externalURL('/directory/mobile') },
    {title: 'Social', url: externalURL('/directory/social') },
    {title: 'Entertainment', url: externalURL('/directory/entertainment') },
    {title: 'Gaming', url: externalURL('/directory/gaming') },
    {title: 'Sports', url: externalURL('/directory/sports') },
    {title: 'News & Events', url: externalURL('/directory/news') },
    {title: 'Animals', url: externalURL('/directory/animals') },
    {title: 'Science & Technology', url: externalURL('/directory/science_tech') },
    {title: 'More', url: externalURL('/directory/other') },
  ]
  
  $('#fp_channel_list li').list (r) ->
    r.title = $(this).find('.channel_title')
    r.url = $(this).find('a')
    r.image = $(this).find('img.screencap')

this.directory = (request) ->
  title $('#category_dropmenu_toggle .dropmenu_toggle a')
  
  $('.list_item').list (r) ->
    r.titleURL = $(this).find('a.title')
    r.image = $(this).find('img.cap').attr('src1')

this.searchForm = () ->
  form 'doSearch', (f) ->
    f.br()
    f.fieldset ->
      f.search('q', {placeholder: 'justin.tv Search', value: $('#q').val()})

this.doSearch = (request) ->
  document.location.href = 'http://www.justin.tv/search?utf8=%E2%9C%93&q=' + encodeURIComponent(request.params.q) + '&commit=Search'
  wait()

this.search = (request) ->
  searchForm()
  
  $('#broadcasts_list li').list (r) ->
    r.titleURL = $(this).find('a.title')
    r.image = $(this).find('img').attr("src1")
    r.imageWidth = 150
    r.imageHeight = 113

this.ageButton = (request) ->
  over18 = $('#over18')

  if request.action == 'over18'
    clickOn over18.next('input')

  else if over18.length > 0
    form = over18.parents('form')

    $('.form_description').each ->
      info $(this).text()

    button form.find('input.pretty_button').attr('value'), 'over18'

    linkTo $('#explore_more_video').text(), externalURL('/')

  else if request.action == 'continueAnyway'
    clickOn $('#roadblock_button')

  else if $('#roadblock_button').length > 0
    button 'continue anyway', 'continueAnyway'

this.tryVideo = (request) ->
  return unless $(this.playerSelector).length > 0
  
  title $('title')

  button('Play/Pause', 'playPause')
  toggle 'Fullscreen', 'toggleFullscreen', player().isFullscreen
  
  relatedChannels()

this.relatedChannels = (request) ->
  $('#related_channels .video').list (r) ->
    r.titleURL = $(this).find('p.title a')
    r.image = $(this).find('img')
    r.subtitle = $(this).find('.channelname')

this.playerSelector = '#archive_site_player_flash,#standard_holder,#live_frontpage_player_flash'

this.player = (selector) ->
  selector ||= this.playerSelector
  player = new Player(selector, scrollY: 50)

  player.setBox width: 'full', valign: 'bottom', height: 26

  player.setPlay x: 12, y: 12, delay: 100
  player.setFullscreenOn align: 'right', x: 12, y: 12, delay: 100

  player
  
  
  
  
  
  
  
  