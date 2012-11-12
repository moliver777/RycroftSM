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
	});
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
	});
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
	});
}

// SAVE BOOKING NEW/EDIT
function completeBooking(id) {
	$("ul#form_errors").empty();
	params = {};
	if ($("select#event_mode").val() != 0) {params["event_id"] = $("select#event_mode").val()};
	$.each($("input.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("input.field[type='checkbox']"), function(i,field) {params[$(field).attr("id")] = $(field).is(":checked")});
	$.each($("select.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	$.each($("textarea.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
	client = {};
	if ($("input#client_id").val() != 0) {client["client_id"] = $("input#client_id").val()};
	$.each($("input.client_field"), function(i,field) {client[$(field).attr("id")] = $(field).val()});
	$.each($("input.client_field[type='checkbox']"), function(i,field) {client[$(field).attr("id")] = $(field).is(":checked")});
	$.each($("select.client_field"), function(i,field) {client[$(field).attr("id")] = $(field).val()});
	$.each($("textarea.client_field"), function(i,field) {client[$(field).attr("id")] = $(field).val()});
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
		});
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
		});
	}
}

// SAVE PAYMENT
function savePayment(id) {
	var id = id;
	$("ul#form_errors").empty();
	params = {};
	params["booking_id"] = id;
	params["amount"] = $("input#amount").val();
	params["payment_type"] = $('input:radio:checked').val();
	params["description"] = $("input#description").val();
	params["payment_date"] = $("input#payment_date").val();
	$.ajax({
		url: "/bookings/create_payment",
		type: "POST",
		data: {fields: params},
		success: function(json) {
			var json = json.errors;
			if (json[0]) {
				$.each(json, function(i,error) {
					$("ul#form_errors").append("<li>"+error+"</li>");
				})
			} else {
				window.location.replace("/bookings/show/"+id);
			}
		}
	});
}

// SAVE OTHER PAYMENT
function saveOtherPayment(id) {
	var id = id;
	$("ul#form_errors").empty();
	params = {};
	params["amount"] = $("input#amount").val();
	params["payment_type"] = $('input:radio:checked').val();
	params["reference"] = $("input#reference").val();
	params["description"] = $("input#description").val();
	params["payment_date"] = $("input#payment_date").val();
	$.ajax({
		url: "/bookings/create_payment",
		type: "POST",
		data: {fields: params},
		success: function(json) {
			var json = json.errors;
			if (json[0]) {
				$.each(json, function(i,error) {
					$("ul#form_errors").append("<li>"+error+"</li>");
				})
			} else {
				window.location.reload();
			}
		}
	});
}

// SAVE EVENT EDIT
function completeEventEdit(id) {
	$("ul#form_errors").empty();
	params = {};
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
		});
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
	});
}

// DELETE BOOKING
function deleteBooking(id,url) {
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
	});
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
						$("input#start_time").val($(this).attr("hour")+":"+$(this).attr("mins")).trigger("change");
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
					$("input#start_time").val("").trigger("change");
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
							$("input#start_time").val("").trigger("change");
							$("input#end_time").val("");
						}
						if (first) {
							if ($(seg2).hasClass("used")) {
								$("#set_time").removeClass("on");
								$("td.selected").removeClass("selected first last")
								$("#set_time").removeClass().addClass("start").html("Set Start Time");
								$("input#start_time").val("").trigger("change");
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
		return "0:00";
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

function fancyConfirmAutoAssign(date) {
	var ret;
	var data;
	var date = date;
	jQuery.fancybox({
		'overlayShow' : true,
		'padding' : 0,
		modal : true,
		content : "<div class='popup_wrapper' id='confirm_popup'><h3>AUTO-ASSIGN</h3><div class='popup_content reduced_height'><p>There are bookings for "+date+" with no horses currently assigned to them.</p><p>Would you like the system to try and auto-assign available horses to each booking?</p><p>WARNING: If suitable horses could not be found, some issues may appear on the home screen.</p><p style='margin-top:10px;'><input type='checkbox' id='no_more_prompts' />Don't show this again today (Auto-assign can be accessed from the bookings page)</p></div><div class=\"options\"><input id=\"fancyConfirm_cancel\" class=\"btn cancel_btn\" type=\"button\" value=\"Cancel\"><input id=\"fancyConfirm_ok\" class=\"btn ok_btn\" type=\"button\" value=\"Assign\" style=\"width:66px;\"></div></div>",
		onComplete : function() {
			jQuery("#fancyConfirm_cancel").click(function() {
				if ($("input#no_more_prompts").is(":checked")) {
					$.ajax({
						url: "/assignment/no_more_prompts",
						type: "POST"
					});
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
					url: "/assignment/auto_assign/"+date,
					type: "POST",
					success: function(json) {
						var data = json;
						var table = "<tr><th>Booking</th><th></th><th>Horse</th></tr>";
						$.each(data, function(booking,horse) { table += "<tr><td>"+booking+"</td><td>=></td><td>"+horse+"</td></tr>" });
						$("div.popup_content").empty().append("<p><table style='margin:auto;'>"+table+"</table></p>");
						$("#fancyConfirm_cancel").hide();
						$("#fancyConfirm_ok").val("Close").attr("disabled",false).unbind("click").click(function() {
							jQuery.fancybox.close();
							window.location.href = "/bookings/date/"+date;
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
	});
}

function fancyAvailableNow() {
	$.ajax({
		url: "/available_now",
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
	});
}

function fancyNextWeek(id) {
	$.ajax({
		url: "/rebook/"+id,
		type: "GET",
		success: function(view) {
			jQuery.fancybox({
				'overlayShow' : true,
				'padding' : 0,
				modal : true,
				content:  "<div class='popup_wrapper' id='confirm_popup'>" + view + "<div class=\"options\"><input id=\"fancyConfirm_cancel\" class=\"btn cancel_btn\" type=\"button\" value=\"Cancel\"><input id=\"fancyConfirm_continue\" class=\"btn continue_btn\" type=\"button\" value=\"Continue\"></div></div>",
				onComplete : function() {
					jQuery("#fancyConfirm_cancel").click(function() {
						jQuery.fancybox.close();
					})
					jQuery("#fancyConfirm_continue").click(function() {
						$("ul#rebook_errors").empty();
						params = {};
						$.each($("input.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
						$.each($("select.field"), function(i,field) {params[$(field).attr("id")] = $(field).val()});
						$.ajax({
							url: "/rebook_status/"+id,
							type: "POST",
							data: params,
							success: function(json) {
								if (json.errors[0]) {
									$.each(json.errors, function(i,error) {
										$("ul#rebook_errors").append("<li>"+error+"</li>");
									})
								} else {
									window.location.href = "/bookings/show/"+json.booking_id;
								}
							}
						});
					})
				}
			});
		}
	});
}

function rebookAll(event_id) {
	$.ajax({
		url: "/rebook_all/"+event_id,
		type: "GET",
		success: function(view) {
			jQuery.fancybox({
				'overlayShow' : true,
				'padding' : 0,
				modal : true,
				content: "<div class='popup_wrapper' id='confirm_popup'>" + view + "<div class=\"options\"><input id=\"fancyConfirm_ok\" class=\"btn ok_btn\" type=\"button\" value=\"Ok\"><input id=\"fancyConfirm_cancel\" class=\"btn cancel_btn\" type=\"button\" value=\"Cancel\"></div></div>",
				onComplete : function() {
					jQuery("#fancyConfirm_ok").click(function() {
						$("ul#rberrors").empty();
						var params = {}
						$.each($("select.field"), function(i,select) {
							params[$(select).attr("id")] = $(select).val();
						})
						$.each($("input.field"), function(i,input) {
							params[$(input).attr("id")] = $(input).val();
						})
						params["copy_horses"] = $("input#copy_horses").is(":checked");
						params["copy_staff"] = $("input#copy_staff").is(":checked");
						params["bookings"] = []
						$.each($("input.booking"), function(i,booking) {
							if ($(booking).is(":checked")) params["bookings"].push({id:$(booking).val(),confirm:$("input.confirm[value='"+$(booking).val()+"']").is(":checked")});
						})
						$.ajax({
							url: "/do_rebook_all",
							type: "POST",
							data: params,
							success: function(json) {
								if (json.errors.length > 0) {
									$.each($(json.errors), function(i,error) {
										$("ul#rberrors").append("<li style='text-align:center;'>"+error+"</li>");
									})
								} else {
									window.location.href = json.event_id ? "/bookings/show_event/"+json.event_id : "/bookings/show/"+json.booking_id;
								}
							}
						})
					})
					jQuery("#fancyConfirm_cancel").click(function() {
						jQuery.fancybox.close();
					})
				}
			})
		}
	})
}

function formatTime(time) {
	if (time.length>0) {
		var hr = parseInt(time.split(":")[0]);
		var fhr = (hr > 12) ? hr-12 : hr;
		var ap = (hr < 12) ? 'am' : 'pm';
		return fhr+":"+time.split(":")[1]+ap;
	} else {
		return ""
	}
}

