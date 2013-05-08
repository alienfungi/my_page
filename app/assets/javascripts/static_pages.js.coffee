# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.validate_comment = () ->
	VALID_EMAIL = new RegExp /^((?!\.)[a-z0-9._%+-]+(?!\.)\w)@[a-z0-9-]+\.[a-z.]{2,5}(?!\.)\w$/i
	name = document.getElementById "comment_name"
	email = document.getElementById "comment_email"
	valid = true

	if name.value == ""
		valid = false
		name.classList.add "error"
		document.getElementById("name_error").innerHTML = "Name is required."
	else
		name.classList.remove "error"
		name_error.innerHTML = ""

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

	# if !valid
	# 	alert "invalid"

	valid