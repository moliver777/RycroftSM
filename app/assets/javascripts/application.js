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

// SAVE NEW/EDIT
function save(root,url) {
	params = {}
	$.each($("input.field"), function(i,field) {
		params[$(field).attr("id")] = $(field).val();
	})
	$.each($("select.field"), function(i,field) {
		params[$(field).attr("id")] = $(field).val();
	})
	$.each($("input.field[type='checkbox']"), function(i,field) {
		params[$(field).attr("id")] = $(field).is(":checked");
	})
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