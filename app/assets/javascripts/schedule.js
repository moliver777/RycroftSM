Schedule = function(events) {
	this.init(events);
}
jQuery.extend(Schedule.prototype, {
	init: function(events) {
		this.events = events;
		console.log(this.events);
		this.setup();
	},

	teardown: function() {
		this.events = null;
	},

	setup: function() {
		var self = this;

		$.each(this.events, function(venue_id,venue_events) {
			$.each(venue_events, function(i,evt) {
				var count = -1;
				$.each($('tr[venue_id="'+venue_id+'"] td.seg:not(.evt)'), function(j,seg) {
					if ($(seg).attr("hour") == evt.hour && $(seg).attr("mins") == evt.mins) {
						$(seg).addClass("evt first").attr("event_id", evt.id);
						count = 1;
					}
					if (count != -1) {
						if (count < evt.duration) {
							count++;
							$(seg).addClass("evt").attr("event_id", evt.id);
						} else {
							count = -1;
							$(seg).addClass("evt last").attr("event_id", evt.id);
						}
					}
					$(seg).mouseover(function(e) {
						$("#schTooltip").html("<strong style='font-size:15px;'>"+evt.name.toUpperCase()+"</strong><br/><strong>Clients:</strong> "+evt.clients+"<br/><strong>Horses:</strong> "+evt.horses);
						$("#schTooltip").css({left:e.pageX+15, top:e.pageY+10});
						$("#schTooltip").show();
					}).mousemove(function(e) {
						$("#schTooltip").css({left:e.pageX+15, top:e.pageY+10});
					}).unbind("click");
				})
			})
		})

		$.each($("td.evt"), function(i,seg) {
			$(seg).click(function() {
				self.route($(this).attr("event_id"));
			})
		})

		$.each($("td:not(.evt)"), function(i,seg) {
			$(seg).mouseover(function() {
				$("#schTooltip").hide();
			})
		})
		$.each($("th"), function(i,hdr) {
			$(hdr).mouseover(function() {
				$("#schTooltip").hide();
			})
		})
		$("table").mouseleave(function() {
			$("#schTooltip").hide();
		})
	},

	route: function(id) {
		window.location.href = "/bookings/show_event/"+id;
	}
})