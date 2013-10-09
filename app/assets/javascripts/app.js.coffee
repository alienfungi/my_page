jQuery ->
  $('ul.nav-tabs').children('li').children('a').click ->
    $("#flash_messages").html("")
