// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .



// INNER CONTENT PANEL HEIGHT
$(document).ready(function() {
	$("#inner_content").css("height", $("#appcontent").height()-40+"px");
})

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
	var popup_msg = "<h3>DELETE</h3><div class='popup_content reduced_height'><p>Delete "+id+".</p><p>Are you sure?</p></div>";
	fancyConfirmOKCancel(popup_msg, function(result) {
		if (result) {
			$.ajax({
				url: url,
				type: "POST",
				success: function() {
					window.location.reload()
				}
			})
		}
	})
}

// CONFIRM RESET
function reset(id,url) {
	var popup_msg = "<h3>PASSWORD RESET</h3><div class='popup_content reduced_height'><p>Reset password for "+id+".</p><p>Are you sure?</p></div>";
	fancyConfirmOKCancel(popup_msg, function(result) {
		if (result) {
			$.ajax({
				url: url,
				type: "POST"
			})
		}
	})
}

// SAVE NEW/EDIT
function save(root,url) {
	$("ul#form_errors").empty();
	params = {}
	$.each($("input.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("input.field[type='checkbox']"), function(i,field) {params[$(field).attr("id")] = $(field).is(":checked")});
	$.each($("select.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("textarea.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.ajax({
		url: url,
		type: "POST",
		data: {fields: params},
		success: function(json) {
			if (json[0]) {
				$.each(json, function(i,error) {
					$("ul#form_errors").append("<li>"+error+"</li>");
				})
			} else {
				window.location.replace(root);
			}
		}
	})
}

// SAVE BOOKING NEW/EDIT
function completeBooking(id) {
	$("ul#form_errors").empty();
	params = {}
	if ($("select#event_mode").val() != 0) {params["event_id"] = $("select#event_mode").val()};
	$.each($("input.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("input.field[type='checkbox']"), function(i,field) {params[$(field).attr("id")] = $(field).is(":checked")});
	$.each($("select.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("textarea.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	client = {};
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
				if (json.errors[0]) {
					$.each(json.errors, function(i,error) {
						$("ul#form_errors").append("<li>"+error+"</li>");
					})
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
				if (json.errors[0]) {
					$.each(json.errors, function(i,error) {
						$("ul#form_errors").append("<li>"+error+"</li>");
					})
				} else {
					if (json.booking_id) {
						window.location.replace("/bookings/show/"+json.booking_id);
					} else {
						window.location.replace("/bookings/show_event/"+json.event_id);
					}
					
				}
			}
		})
	}
}

// SAVE EVENT EDIT
function completeEventEdit(id) {
	$("ul#form_errors").empty();
	params = {}
	if ($("select#event_mode").val() != 0) {params["event_id"] = $("select#event_mode").val()};
	$.each($("input.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("input.field[type='checkbox']"), function(i,field) {params[$(field).attr("id")] = $(field).is(":checked")});
	$.each($("select.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("textarea.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	if (params["event_id"]) {
		$.ajax({
			url: "/bookings/update_event/"+params["event_id"],
			type: "POST",
			data: {fields: params},
			success: function(json) {
				if (json.errors[0]) {
					$.each(json.errors, function(i,error) {
						$("ul#form_errors").append("<li>"+error+"</li>");
					})
				} else {
					window.location.replace("/bookings/show_event/"+json.event_id);
				}
			}
		})
	} else {
		$.ajax({
			url: "/bookings/create",
			type: "POST",
			data: {fields: params},
			success: function(json) {
				if (json.errors[0]) {
					$.each(json.errors, function(i,error) {
						$("ul#form_errors").append("<li>"+error+"</li>");
					})
				} else {
					if (json.booking_id) {
						window.location.replace("/bookings/show/"+json.booking_id);
					} else {
						window.location.replace("/bookings/show_event/"+json.event_id);
					}
					
				}
			}
		})
	}
}

// CANCEL BOOKING
function cancelBooking(id,url) {
	var popup_msg = "<h3>CANCEL</h3><div class='popup_content reduced_height'><p>Cancel "+id+".</p><p>Are you sure?</p></div>";
	fancyConfirmOKCancel(popup_msg, function(result) {
		if (result) {
			$.ajax({
				url: url,
				type: "POST",
				success: function() {
					window.location.reload()
				}
			})
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
						$("input#venue_id").val($(this).parent().attr("id"));
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
	mins = parseInt($(seg).attr("mins"));
	hour = ($(seg).attr("hour")[0] == "0") ? parseInt($(seg).attr("hour")[1]) : parseInt($(seg).attr("hour"));
	next_mins = mins+15;
	next_mins = (next_mins == 60) ? "00" : String(next_mins);
	next_hour = (next_mins == "00") ? hour+1 : hour;
	next_hour = (next_hour < 10) ? "0"+String(next_hour) : String(next_hour);
	return next_hour+":"+next_mins;
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

// FANCYBOX POPUPS
function fancyConfirmOKCancel(msg,callback) {
	var ret;
	jQuery.fancybox({
		'overlayShow' : true,
		'padding' : 0,
		modal : true,
		content : "<div class='popup_wrapper' id='confirm_popup'>" + msg + "<div class=\"options\"><input id=\"fancyConfirm_cancel\" class=\"btn cancel_btn\" type=\"button\" value=\"Cancel\"><input id=\"fancyConfirm_ok\" class=\"btn ok_btn\" type=\"button\" value=\"Ok\" style=\"width:66px;\"></div></div>",
		onComplete : function() {
			jQuery("#fancyConfirm_cancel").click(function() {
				ret = false; 
				jQuery.fancybox.close();
			})
			jQuery("#fancyConfirm_ok").click(function() {
				ret = true; 
				jQuery.fancybox.close();
			})
		},
		onClosed : function() {
			callback.call(this,ret);
		}
	});
}

function fancyConfirmAutoAssign() {
	var ret;
	var data;
	jQuery.fancybox({
		'overlayShow' : true,
		'padding' : 0,
		modal : true,
		content : "<div class='popup_wrapper' id='confirm_popup'><h3>AUTO-ASSIGN</h3><div class='popup_content reduced_height'><p>There are bookings today with no horses currently assigned to them.</p><p>Would you like the system to try and auto-assign available horses to each booking?</p><p>WARNING: If suitable horses could not be found, some issues may appear on the home screen.</p><p style='margin-top:10px;'><input type='checkbox' id='no_more_prompts' />Don't show this again today (Auto-assign can be accessed from the bookings page)</p></div><div class=\"options\"><input id=\"fancyConfirm_cancel\" class=\"btn cancel_btn\" type=\"button\" value=\"Cancel\"><input id=\"fancyConfirm_ok\" class=\"btn ok_btn\" type=\"button\" value=\"Assign\" style=\"width:66px;\"></div></div>",
		onComplete : function() {
			jQuery("#fancyConfirm_cancel").click(function() {
				if ($("input#no_more_prompts").is(":checked")) {
					$.ajax({
						url: "/assignment/no_more_prompts",
						type: "POST"
					})
				}
				jQuery.fancybox.close();
			})
			jQuery("#fancyConfirm_ok").click(function() {
				if ($("input#no_more_prompts").is(":checked")) {
					$.ajax({
						url: "/assignment/no_more_prompts",
						type: "POST"
					})
				}
				$("#fancyConfirm_ok").attr("disabled",true);
				$("#fancyConfirm_cancel").attr("disabled",true);
				$("div.popup_content").empty().append("<p>Please wait...</p>");
				$.ajax({
					url: "/assignment/auto_assign",
					type: "POST",
					success: function(json) {
						var data = json;
						var table = "<tr><th>Booking</th><th></th><th>Horse</th></tr>";
						$.each(data, function(booking,horse) { table += "<tr><td>"+booking+"</td><td>=></td><td>"+horse+"</td></tr>" });
						$("div.popup_content").empty().append("<p><table style='margin:auto;'>"+table+"</table></p>");
						$("#fancyConfirm_cancel").hide();
						$("#fancyConfirm_ok").val("Close").attr("disabled",false).unbind("click").click(function() {
							jQuery.fancybox.close();
							window.location.href = "/schedule";
						});
					}
				})
			})
		}
	});
}

function fancyPriceList() {
	$.ajax({
		url: "/price_list",
		type: "GET",
		success: function(view) {
			jQuery.fancybox({
				'overlayShow' : true,
				'padding' : 0,
				modal : true,
				content: "<div class='popup_wrapper' id='confirm_popup'>" + view + "<div class=\"options\"><input id=\"fancyConfirm_close\" class=\"btn close_btn\" type=\"button\" value=\"Close\"></div></div>",
				onComplete : function() {
					jQuery("#fancyConfirm_close").click(function() {
						jQuery.fancybox.close();
					})
				}
			})
		}
	})
}
