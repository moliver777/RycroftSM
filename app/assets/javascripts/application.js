// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

// CONFIRM DELETE
function confirmation(id,url) {
	var result = confirm("Delete "+id+". Are you sure?")
	if (result) {
		$.ajax({
			url: url,
			type: "POST",
			success: function() {
				window.location.reload()
			}
		})
	}
}

// CONFIRM RESET
function reset(id,url) {
	var result = confirm("Reset password for "+id+". The password will be set to 'password'. Are you sure?");
	if (result) {
		$.ajax({
			url: url,
			type: "POST"
		})
	}
}

// SAVE NEW/EDIT
function save(root,url) {
	params = {}
	$.each($("input.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("input.field[type='checkbox']"), function(i,field) {params[$(field).attr("id")] = $(field).is(":checked")});
	$.each($("select.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("textarea.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.ajax({
		url: url,
		type: "POST",
		data: {fields: params},
		success: function() {
			window.location.replace(root)
		}
	})
}

// CANCEL NEW/EDIT
function cancel(url) {
	window.location.replace(url)
}

// CLIENT SEARCH
$(document).ready(function() {
	$("button#search").unbind("click").click(function() {
		window.location.href = "/search/"+$("input#search_field").val();
	})
	$("input#search_field").keypress(function(event) {
		if (event.which == 13) $("button#search").trigger("click");
	})
})