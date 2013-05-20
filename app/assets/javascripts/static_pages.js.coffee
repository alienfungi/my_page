# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#if document.getElementById("packman")
$(document).ready ->

	$('#sidebarInner .expandable').on 'mouseenter', '.expander', () ->
		$(this).addClass 'last'
		$(this).closest('.expandable').find('.expansion').slideDown 250
		false

	$('#sidebarInner .expandable').on 'mouseleave', () ->
		$(this).find('.expansion').slideUp 'fast'
		$(this).find('.expander').removeClass('last')
		$('#sidebarInner > nav > ul').children().last().children('a').addClass('last')

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
		name = document.getElementById "comment_name"
		email = document.getElementById "comment_email"
		valid = true

		# validate name field
		if name.value == ""
			valid = false
			name.classList.add "error"
			document.getElementById("name_error").innerHTML = "Name is required."
		else
			name.classList.remove "error"
			name_error.innerHTML = ""

		# validate email field
		if email.value == ""
			valid = false
			email.classList.add "error"
			document.getElementById("email_error").innerHTML = "Email is required."
		else if !VALID_EMAIL.test email.value
			valid = false
			email.classList.add "error"
			document.getElementById("email_error").innerHTML = "Email is invalid."
		else
			email.classList.remove "error"
			email_error.innerHTML = ""

		valid

	window.post_score = (arg) ->
		display = document.getElementById("score")
		if display != null
			display.innerHTML = "score: " + arg

	window.post_lives = (arg) ->
		display = document.getElementById("lives")
		if display != null
			display.innerHTML = "lives: " + arg