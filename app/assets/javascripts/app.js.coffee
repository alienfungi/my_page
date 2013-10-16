jQuery ->
  # polling
  updatePage = ->
    $.ajax '/users/poll',
      type: 'GET'
      dataType: 'script'
      setTimeout(updatePage, 5000)
  setTimeout updatePage, 5000

  # remove flash messages on tab clicks
  $('ul.nav-tabs').children('li').children('a').click ->
    $("#flash_messages").html("")

  # smooth scroll to top with footer link
  $('#scroll_top').click ->
    $('html, body').stop().animate(
      scrollTop: 0
    , 'fast')

