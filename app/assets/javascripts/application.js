// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


// LINK BUTTONS
$(document).ready(function() {
	$.each($("button.link"), function(i,link) {
		$(link).unbind("click").click(function() {
			window.location.href = $(this).attr("link");
		})
	})
})

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

// SAVE BOOKING NEW/EDIT
function completeBooking(id) {
	params = {}
	if ($("select#event_mode").val() != 0) {params["event_id"] = $("select#event_mode").val()};
	$.each($("input.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("input.field[type='checkbox']"), function(i,field) {params[$(field).attr("id")] = $(field).is(":checked")});
	$.each($("select.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("textarea.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	client = {}
	if ($("input#client_id").val() != 0) {client["client_id"] = $("input#client_id").val()};
	$.each($("input.client_field"), function(i,field) {client[$(field).attr("id")] = $(field).val()});
	$.each($("select.client_field"), function(i,field) {client[$(field).attr("id")] = $(field).val()});
	params["client"] = client;
	if (id) {
		$.ajax({
			url: "/bookings/update/"+id,
			type: "POST",
			data: {fields: params},
			success: function(json) {
				if (json.error) {
				
				} else {
					window.location.replace("/bookings/show/"+json.booking_id);
				}
			}
		})
	} else {
		$.ajax({
			url: "/bookings/create",
			type: "POST",
			data: {fields: params},
			success: function(json) {
				if (json.error) {
				
				} else {
					window.location.replace("/bookings/show/"+json.booking_id);
				}
			}
		})
	}
}

// CANCEL BOOKING
function cancelBooking(id,url) {
	var result = confirm("Cancel "+id+". Are you sure?")
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

// INTERACTION WITH BOOKING TIMETABLE
function timetableInteraction() {
	if ($("#set_time").hasClass("start")) {
		$("#set_time").unbind("click").click(function() {
			var self = this;
			$(this).addClass("on");
			$.each($("td.seg"), function(i,seg) {
				$(seg).unbind('click').click(function() {
					$("td.seg").unbind("click");
					if ($(this).hasClass("used")) {
						$(self).removeClass("on");
					} else {
						$("input#start_time").val($(this).attr("hour")+":"+$(this).attr("mins"));
						$(this).addClass("selected first");
						$(self).removeClass().addClass("end on").html("Set End Time");
						timetableInteraction();
					}
				})
			})
		})
	} else {
		$.each($("td.seg"), function(i,seg) {
			$(seg).unbind('click').click(function() {
				$("td.seg").unbind("click");
				if ($(this).hasClass("used")) {
					$("#set_time").removeClass("on");
					$("td.selected").removeClass("selected first")
					$("#set_time").removeClass().addClass("start").html("Set Start Time");
					$("input#start_time").val("");
					$("input#end_time").val("");
				} else {
					$("input#end_time").val(nextSeg(this));
					$(this).addClass("selected last");
					var first = false;
					$.each($("td.seg"), function(j,seg2) {
						if ($(seg2).hasClass("selected last") && !first) {
							$("#set_time").removeClass("on");
							$("td.selected").removeClass("selected first last");
							$("#set_time").removeClass().addClass("start").html("Set Start Time");
							$("input#start_time").val("");
							$("input#end_time").val("");
						}
						if (first) {
							if ($(seg2).hasClass("used")) {
								$("#set_time").removeClass("on");
								$("td.selected").removeClass("selected first last")
								$("#set_time").removeClass().addClass("start").html("Set Start Time");
								$("input#start_time").val("");
								$("input#end_time").val("");
								first = false;
							} else if ($(seg2).hasClass("selected last")) {
								$("#set_time").removeClass("on").attr("disabled", "disabled").html("Finished Setting Time");
								first = false;
							} else {
								$(seg2).addClass("selected");
							}
						}
						if ($(seg2).hasClass("selected first")) first = true;
					})
				}
				$("input#duration").val(calculateDuration());
			})
		})
	}
}

// GET TIME FROM FOLLOWING SEGMENT
function nextSeg(seg) {
	next_mins = parseInt($(seg).attr("mins"))+15;
	next_mins = (next_mins == 60) ? "00" : String(next_mins);
	next_hour = (next_mins == "00") ? parseInt($(seg).attr("hour"))+1 : parseInt($(seg).attr("hour"));
	next_hour = (next_hour < 10) ? "0"+String(next_hour) : String(next_hour);
	return next_hour+":"+next_mins
}

// CALCULATE DURATION OF BOOKING IN SEGMENTS
function calculateDuration() {
	var segs = $("td.selected").length;
	if (segs == 0) {
		return "0:00"
	} else {
		mins = segs*15;
		hours = Math.floor(mins/60);
		mins = mins-(hours*60);
		mins = (mins==0) ? "00" : String(mins);
		return String(hours)+":"+mins;
	}
}