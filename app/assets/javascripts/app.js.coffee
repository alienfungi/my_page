jQuery ->
  $('ul.nav-tabs').children('li').children('a').click ->
    $("#flash_messages").html("")

  $('#scroll_top').click ->
    $('html, body').stop().animate(
      scrollTop: 0
    , 'fast')
