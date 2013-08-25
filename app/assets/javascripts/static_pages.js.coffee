# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#if document.getElementById("packman")
$(document).ready ->
  packmanResize = () ->
    packman = document.getElementById "packman"
    correct_ratio = 22 / 19
    width = $("#packman").width()
    if packman != null
      packman.style.height = (width * correct_ratio) + "px"

  # on resize
  $(window).resize -> packmanResize()
  # on init
  packmanResize()

  window.validate_comment = () ->
    VALID_EMAIL = new RegExp /^((?!\.)[a-z0-9._%+-]+(?!\.)\w)@[a-z0-9-]+\.[a-z.]{2,5}(?!\.)\w$/i
    name = $("#comment_name")
    email = $("#comment_email")
    valid = true

    # validate name field
    if name.val() == ""
      valid = false
      name.parent().addClass "has-error"
    else
      name.parent().removeClass "has-error"

    # validate email field
    if email.val() == ""
      valid = false
      email.parent().removeClass "has-warning"
      email.parent().addClass "has-error"
    else if !VALID_EMAIL.test email.value
      valid = false
      email.parent().removeClass "has-error"
      email.parent().addClass "has-warning"
    else
      email.parent().removeClass "has-error"
      email.parent().removeClass "has-warning"

    valid

  window.post_score = (arg) ->
    display = document.getElementById("score")
    if display != null
      display.innerHTML = "score: " + arg

  window.post_lives = (arg) ->
    display = document.getElementById("lives")
    if display != null
      display.innerHTML = "lives: " + arg

  $('#javaThumbs').on 'mouseenter', '.container', ()->
    $(this).stop(true, true).animate {'opacity': '1'}

  $('#javaThumbs').on 'mouseleave', '.container', ()->
    $(this).stop(true, true).animate {'opacity': '0.75'}
