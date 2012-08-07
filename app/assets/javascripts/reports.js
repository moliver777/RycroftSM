var REPORTS = {
	create: function(options) {
		switch (options.name) {
			case "horse_workloads" :
				this.horse_workloads(options);
			break;
			case "horse_events" :
				this.horse_events(options);
			break;
			case "horse_standards" :
				this.horse_standards(options);
			break;
			case "client_ages" :
				this.client_ages(options);
			break;
			case "client_events" :
				this.client_events(options);
			break;
			case "client_standards" :
				this.client_standards(options);
			break;
			case "event_types" :
				this.event_types(options);
			break;
			case "bookings_by_day" :
				this.bookings_by_day(options);
			break;
			case "bookings_by_hour" :
				this.bookings_by_hour(options);
			break;
		}
	},

	horse_workloads: function(options) {
		var max = 0
		var count = options.data.length;
		$.each(options.data, function(i,d) {
			if (d.workload > max) max = d.workload;
		})
		var width = $(options.container).width()-80;
		var height = 200;
		var x = d3.scale.linear()
			.domain([0, count])
			.range([0, width]);
		var y = d3.scale.linear()
			.domain([0, max])
			.range([0, height]);

		var container = d3.select("#"+$(options.container).attr('id'))
			.append("svg:svg")
			.attr("width",$(options.container).css("width"))
			.attr("height","230px")
			.attr("id","horseWorkloadsSvg");

		var svg = d3.select("svg#horseWorkloadsSvg")
			.append("svg:g")
			.attr("id", "workloadsChart");

		var chart = d3.select("g#workloadsChart");

		try {
			if (max > 0) {
				$.each(options.data, function(i,horse) {
					chart.append("svg:rect")
						.attr("x",x(i))
						.attr("y",y(max)-y(horse.workload))
						.attr("width",x(1)+"px")
						.attr("height",y(horse.workload)+"px")
						.attr("fill", function(){return i%2 ? "#5F5F5F" : "#CCCCCC"});
					svg.append("svg:text")
						.attr("x",x(i)+2)
						.attr("y",y(max)+10)
						.text((horse.name.length > 10) ? horse.name.substr(0,8)+".." : horse.name);
				})
			}
		} catch (e) {
			// console.log(e)
		}

		chart.append("svg:line")
			.attr("x1",x(count))
			.attr("x2",x(count))
			.attr("y1",y(0))
			.attr("y2",y(max))
			.attr("stroke","#000");
		chart.append("svg:line")
			.attr("x1",x(0))
			.attr("x2",x(count))
			.attr("y1",y(max))
			.attr("y2",y(max))
			.attr("stroke","#000")
			.attr("transform","translate(0,-1)");

		if (max > 0) {
			svg.append("svg:text")
				.attr("x",x(count)+5)
				.attr("y",10)
				.style("text-anchor","right")
				.text(max+"hrs");
		} else {
			svg.append("svg:text")
				.attr("x",(width/2)+10)
				.attr("y",20)
				.style("text-anchor","right")
				.text("No data");
		}
	},

	horse_events: function(options) {
		var max = 0
		var count = options.data.length;
		$.each(options.data, function(i,d) {
			if (d.events > max) max = d.events;
		})
		var width = $(options.container).width()-80;
		var height = 200;
		var x = d3.scale.linear()
			.domain([0, count])
			.range([0, width]);
		var y = d3.scale.linear()
			.domain([0, max])
			.range([0, height]);

		var container = d3.select("#"+$(options.container).attr('id'))
			.append("svg:svg")
			.attr("width",$(options.container).css("width"))
			.attr("height","230px")
			.attr("id","horseEventsSvg");

		var svg = d3.select("svg#horseEventsSvg")
			.append("svg:g")
			.attr("id", "heventsChart");

		var chart = d3.select("g#heventsChart");

		try {
			if (max > 0) {
				$.each(options.data, function(i,horse) {
					chart.append("svg:rect")
						.attr("x",x(i))
						.attr("y",y(max)-y(horse.events))
						.attr("width",x(1)+"px")
						.attr("height",y(horse.events)+"px")
						.attr("fill", function(){return i%2 ? "#5F5F5F" : "#CCCCCC"});
					svg.append("svg:text")
						.attr("x",x(i)+2)
						.attr("y",y(max)+10)
						.text((horse.name.length > 10) ? horse.name.substr(0,8)+".." : horse.name);
				})
			}
		} catch (e) {
			// console.log(e)
		}

		chart.append("svg:line")
			.attr("x1",x(count))
			.attr("x2",x(count))
			.attr("y1",y(0))
			.attr("y2",y(max))
			.attr("stroke","#000");
		chart.append("svg:line")
			.attr("x1",x(0))
			.attr("x2",x(count))
			.attr("y1",y(max))
			.attr("y2",y(max))
			.attr("stroke","#000")
			.attr("transform","translate(0,-1)");

		if (max > 0) {
			svg.append("svg:text")
				.attr("x",x(count)+5)
				.attr("y",10)
				.style("text-anchor","right")
				.text(max);
		} else {
			svg.append("svg:text")
				.attr("x",(width/2)+10)
				.attr("y",20)
				.style("text-anchor","right")
				.text("No data");
		}
	},

	horse_standards: function(options) {
		var arc = d3.svg.arc();
		var pie = d3.layout.pie();
		var count = options.data.length;
		var width = $(options.container).width()-80;
		var height = options.mini ? 120 : 200;
		var radius = height/2

		// arcs definition
		function arcs(x,y) {
			var current_arcs = pie(x);
			var new_arcs = pie(y);
			var i = -1;
			var arc;
			while (++i < count) {
				arc = current_arcs[i];
				arc.innerRadius = 0;
				arc.outerRadius = radius;
				arc.next = new_arcs[i];
			}
			return current_arcs;
		}

		var container = d3.select("#"+$(options.container).attr('id'))
			.append("svg:svg")
			.attr("width",$(options.container).css("width"))
			.attr("height",(height+30)+"px")
			.attr("id","horseStandardsSvg");

		var svg = d3.select("svg#horseStandardsSvg")
			.append("svg:g")
			.attr("id", "hstandardsChart");

		var chart = d3.select("g#hstandardsChart");

		// create paths
		var data = [];
		$.each(options.data, function(i,horse) {data.push(horse.count)});
		try {
			chart.selectAll("g.hstandards_arc")
				.data(arcs(data,data))
				.enter().append("svg:g")
				.attr("class","hstandards_arc")
				.attr("transform","translate("+((width/2)+(radius/2))+","+(radius+5)+")")
				.append("svg:path")
				.attr("fill",function(d,i){return (i==0) ? '#EEEEEE': ((i==1) ? '#CCCCCC' : '#5F5F5F')})
				.attr("d",arc)
				.attr("id",function(d,i){return i});

			// legend
			chart.append("svg:rect")
				.attr("x",(width/6)+10)
				.attr("y",height+10)
				.attr("width","10px")
				.attr("height","10px")
				.attr("stroke","#000000")
				.attr("fill","#EEEEEE");
			chart.append("svg:text")
				.attr("x",(width/6)+22)
				.attr("y",height+20)
				.text("Beginner");
			chart.append("svg:rect")
				.attr("x",((width/6)*3)+10)
				.attr("y",height+10)
				.attr("width","10px")
				.attr("height","10px")
				.attr("stroke","#000000")
				.attr("fill","#CCCCCC");
			chart.append("svg:text")
				.attr("x",((width/6)*3)+22)
				.attr("y",height+20)
				.text("Inter");
			chart.append("svg:rect")
				.attr("x",((width/6)*5)+10)
				.attr("y",height+10)
				.attr("width","10px")
				.attr("height","10px")
				.attr("stroke","#000000")
				.attr("fill","#5F5F5F");
			chart.append("svg:text")
				.attr("x",((width/6)*5)+22)
				.attr("y",height+20)
				.text("Advanced");
		} catch (e) {
			svg.append("svg:text")
				.attr("x",(width/2)+10)
				.attr("y",20)
				.style("text-anchor","right")
				.text("No data");
			// console.log(e)
		}
		if (options.mini) {
			$(options.container).append("<span>Horse Standards</span>")
		}
	},

	client_ages: function(options) {
		var max = 0
		var count = options.data.length;
		$.each(options.data, function(i,d) {
			if (d.count > max) max = d.count;
		})
		var width = $(options.container).width()-80;
		var height = 200;
		var x = d3.scale.linear()
			.domain([0, count])
			.range([0, width]);
		var y = d3.scale.linear()
			.domain([0, max])
			.range([0, height]);

		var container = d3.select("#"+$(options.container).attr('id'))
			.append("svg:svg")
			.attr("width",$(options.container).css("width"))
			.attr("height","230px")
			.attr("id","clientAgesSvg");

		var svg = d3.select("svg#clientAgesSvg")
			.append("svg:g")
			.attr("id", "agesChart");

		var chart = d3.select("g#agesChart");

		try {
			if (max > 0) {
				$.each(options.data, function(i,group) {
					chart.append("svg:rect")
						.attr("x",x(i))
						.attr("y",y(max)-y(group.count))
						.attr("width",x(1)+"px")
						.attr("height",y(group.count)+"px")
						.attr("fill", function(){return i%2 ? "#5F5F5F" : "#CCCCCC"});
					svg.append("svg:text")
						.attr("x",x(i)+2)
						.attr("y",y(max)+10)
						.text(group.name);
				})
			}
		} catch (e) {
			// console.log(e)
		}

		chart.append("svg:line")
			.attr("x1",x(count))
			.attr("x2",x(count))
			.attr("y1",y(0))
			.attr("y2",y(max))
			.attr("stroke","#000");
		chart.append("svg:line")
			.attr("x1",x(0))
			.attr("x2",x(count))
			.attr("y1",y(max))
			.attr("y2",y(max))
			.attr("stroke","#000")
			.attr("transform","translate(0,-1)");

		if (max > 0) {
			svg.append("svg:text")
				.attr("x",x(count)+5)
				.attr("y",10)
				.style("text-anchor","right")
				.text(max);
		} else {
			svg.append("svg:text")
				.attr("x",(width/2)+10)
				.attr("y",20)
				.style("text-anchor","right")
				.text("No data");
		}
	},

	client_events: function(options) {
		var max = 0
		var count = options.data.length;
		$.each(options.data, function(i,d) {
			if (d.events > max) max = d.events;
		})
		var width = $(options.container).width()-80;
		var height = 200;
		var x = d3.scale.linear()
			.domain([0, count])
			.range([0, width]);
		var y = d3.scale.linear()
			.domain([0, max])
			.range([0, height]);

		var container = d3.select("#"+$(options.container).attr('id'))
			.append("svg:svg")
			.attr("width",$(options.container).css("width"))
			.attr("height","230px")
			.attr("id","clientEventsSvg");

		var svg = d3.select("svg#clientEventsSvg")
			.append("svg:g")
			.attr("id", "ceventsChart");

		var chart = d3.select("g#ceventsChart");

		try {
			if (max > 0) {
				$.each(options.data, function(i,client) {
					chart.append("svg:rect")
						.attr("x",x(i))
						.attr("y",y(max)-y(client.events))
						.attr("width",x(1)+"px")
						.attr("height",y(client.events)+"px")
						.attr("fill", function(){return i%2 ? "#5F5F5F" : "#CCCCCC"});
					svg.append("svg:text")
						.attr("x",x(i)+2)
						.attr("y",y(max)+10)
						.text((client.name.length > 10) ? client.name.substr(0,8)+".." : client.name);
				})
			}
		} catch (e) {
			// console.log(e)
		}

		chart.append("svg:line")
			.attr("x1",x(count))
			.attr("x2",x(count))
			.attr("y1",y(0))
			.attr("y2",y(max))
			.attr("stroke","#000");
		chart.append("svg:line")
			.attr("x1",x(0))
			.attr("x2",x(count))
			.attr("y1",y(max))
			.attr("y2",y(max))
			.attr("stroke","#000")
			.attr("transform","translate(0,-1)");

		if (max > 0) {
			svg.append("svg:text")
				.attr("x",x(count)+5)
				.attr("y",10)
				.style("text-anchor","right")
				.text(max);
		} else {
			svg.append("svg:text")
				.attr("x",(width/2)+10)
				.attr("y",20)
				.style("text-anchor","right")
				.text("No data");
		}
	},

	client_standards: function(options) {
		var arc = d3.svg.arc();
		var pie = d3.layout.pie();
		var count = options.data.length;
		var width = $(options.container).width()-80;
		var height = options.mini ? 120 : 200;
		var radius = height/2

		// arcs definition
		function arcs(x,y) {
			var current_arcs = pie(x);
			var new_arcs = pie(y);
			var i = -1;
			var arc;
			while (++i < count) {
				arc = current_arcs[i];
				arc.innerRadius = 0;
				arc.outerRadius = radius;
				arc.next = new_arcs[i];
			}
			return current_arcs;
		}

		var container = d3.select("#"+$(options.container).attr('id'))
			.append("svg:svg")
			.attr("width",$(options.container).css("width"))
			.attr("height",(height+30)+"px")
			.attr("id","clientStandardsSvg");

		var svg = d3.select("svg#clientStandardsSvg")
			.append("svg:g")
			.attr("id", "cstandardsChart");

		var chart = d3.select("g#cstandardsChart");

		// create paths
		var data = [];
		$.each(options.data, function(i,client) {data.push(client.count)});
		try {
			chart.selectAll("g.cstandards_arc")
				.data(arcs(data,data))
				.enter().append("svg:g")
				.attr("class","cstandards_arc")
				.attr("transform","translate("+((width/2)+(radius/2))+","+(radius+5)+")")
				.append("svg:path")
				.attr("fill",function(d,i){return (i==0) ? '#EEEEEE': ((i==1) ? '#CCCCCC' : '#5F5F5F')})
				.attr("d",arc)
				.attr("id",function(d,i){return i});

			// legend
			chart.append("svg:rect")
				.attr("x",(width/6)+10)
				.attr("y",height+10)
				.attr("width","10px")
				.attr("height","10px")
				.attr("stroke","#000000")
				.attr("fill","#EEEEEE");
			chart.append("svg:text")
				.attr("x",(width/6)+22)
				.attr("y",height+20)
				.text("Beginner");
			chart.append("svg:rect")
				.attr("x",((width/6)*3)+10)
				.attr("y",height+10)
				.attr("width","10px")
				.attr("height","10px")
				.attr("stroke","#000000")
				.attr("fill","#CCCCCC");
			chart.append("svg:text")
				.attr("x",((width/6)*3)+22)
				.attr("y",height+20)
				.text("Inter");
			chart.append("svg:rect")
				.attr("x",((width/6)*5)+10)
				.attr("y",height+10)
				.attr("width","10px")
				.attr("height","10px")
				.attr("stroke","#000000")
				.attr("fill","#5F5F5F");
			chart.append("svg:text")
				.attr("x",((width/6)*5)+22)
				.attr("y",height+20)
				.text("Advanced");
		} catch (e) {
			svg.append("svg:text")
				.attr("x",(width/2)+10)
				.attr("y",20)
				.style("text-anchor","right")
				.text("No data");
			// console.log(e)
		}
		if (options.mini) {
			$(options.container).append("<span>Client Standards</span>")
		}
	},

	event_types: function(options) {
		var max = 0
		var count = options.data.length;
		$.each(options.data, function(i,d) {
			if (d.count > max) max = d.count;
		})
		var width = $(options.container).width()-80;
		var height = 200;
		var x = d3.scale.linear()
			.domain([0, count])
			.range([0, width]);
		var y = d3.scale.linear()
			.domain([0, max])
			.range([0, height]);

		var container = d3.select("#"+$(options.container).attr('id'))
			.append("svg:svg")
			.attr("width",$(options.container).css("width"))
			.attr("height","230px")
			.attr("id","eventTypesSvg");

		var svg = d3.select("svg#eventTypesSvg")
			.append("svg:g")
			.attr("id", "typesChart");

		var chart = d3.select("g#typesChart");

		try {
			if (max > 0) {
				$.each(options.data, function(i,type) {
					chart.append("svg:rect")
						.attr("x",x(i))
						.attr("y",y(max)-y(type.count))
						.attr("width",x(1)+"px")
						.attr("height",y(type.count)+"px")
						.attr("fill", function(){return i%2 ? "#5F5F5F" : "#CCCCCC"});
					svg.append("svg:text")
						.attr("x",x(i)+2)
						.attr("y",y(max)+10)
						.text(type.name);
				})
			}
		} catch (e) {
			// console.log(e)
		}

		chart.append("svg:line")
			.attr("x1",x(count))
			.attr("x2",x(count))
			.attr("y1",y(0))
			.attr("y2",y(max))
			.attr("stroke","#000");
		chart.append("svg:line")
			.attr("x1",x(0))
			.attr("x2",x(count))
			.attr("y1",y(max))
			.attr("y2",y(max))
			.attr("stroke","#000")
			.attr("transform","translate(0,-1)");

		if (max > 0) {
			svg.append("svg:text")
				.attr("x",x(count)+5)
				.attr("y",10)
				.style("text-anchor","right")
				.text(max);
		} else {
			svg.append("svg:text")
				.attr("x",(width/2)+10)
				.attr("y",20)
				.style("text-anchor","right")
				.text("No data");
		}
	},

	bookings_by_day: function(options) {
		var max = 0
		var count = options.data.length;
		$.each(options.data, function(i,d) {
			if (d.count > max) max = d.count;
		})
		var width = $(options.container).width()-80;
		var height = 200;
		var x = d3.scale.linear()
			.domain([0, count])
			.range([0, width]);
		var y = d3.scale.linear()
			.domain([0, max])
			.range([0, height]);

		var container = d3.select("#"+$(options.container).attr('id'))
			.append("svg:svg")
			.attr("width",$(options.container).css("width"))
			.attr("height","230px")
			.attr("id","dayBookingsSvg");

		var svg = d3.select("svg#dayBookingsSvg")
			.append("svg:g")
			.attr("id", "dbookingChart");

		var chart = d3.select("g#dbookingChart");

		try {
			if (max > 0) {
				$.each(options.data, function(i,day) {
					chart.append("svg:rect")
						.attr("x",x(i))
						.attr("y",y(max)-y(day.count))
						.attr("width",x(1)+"px")
						.attr("height",y(day.count)+"px")
						.attr("fill", function(){return i%2 ? "#5F5F5F" : "#CCCCCC"});
					svg.append("svg:text")
						.attr("x",x(i)+2)
						.attr("y",y(max)+10)
						.text(day.name);
				})
			}
		} catch (e) {
			// console.log(e)
		}

		chart.append("svg:line")
			.attr("x1",x(count))
			.attr("x2",x(count))
			.attr("y1",y(0))
			.attr("y2",y(max))
			.attr("stroke","#000");
		chart.append("svg:line")
			.attr("x1",x(0))
			.attr("x2",x(count))
			.attr("y1",y(max))
			.attr("y2",y(max))
			.attr("stroke","#000")
			.attr("transform","translate(0,-1)");

		if (max > 0) {
			svg.append("svg:text")
				.attr("x",x(count)+5)
				.attr("y",10)
				.style("text-anchor","right")
				.text(max);
		} else {
			svg.append("svg:text")
				.attr("x",(width/2)+10)
				.attr("y",20)
				.style("text-anchor","right")
				.text("No data");
		}
	},

	bookings_by_hour: function(options) {
		var max = 0
		var count = options.data.length;
		$.each(options.data, function(i,d) {
			if (d.count > max) max = d.count;
		})
		var width = $(options.container).width()-80;
		var height = 200;
		var x = d3.scale.linear()
			.domain([0, count])
			.range([0, width]);
		var y = d3.scale.linear()
			.domain([0, max])
			.range([0, height]);

		var container = d3.select("#"+$(options.container).attr('id'))
			.append("svg:svg")
			.attr("width",$(options.container).css("width"))
			.attr("height","230px")
			.attr("id","hourBookingsSvg");

		var svg = d3.select("svg#hourBookingsSvg")
			.append("svg:g")
			.attr("id", "hbookingChart");

		var chart = d3.select("g#hbookingChart");

		try {
			if (max > 0) {
				$.each(options.data, function(i,hour) {
					chart.append("svg:rect")
						.attr("x",x(i))
						.attr("y",y(max)-y(hour.count))
						.attr("width",x(1)+"px")
						.attr("height",y(hour.count)+"px")
						.attr("fill", function(){return i%2 ? "#5F5F5F" : "#CCCCCC"});
					svg.append("svg:text")
						.attr("x",x(i)+2)
						.attr("y",y(max)+10)
						.text(hour.name);
				})
			}
		} catch (e) {
			// console.log(e)
		}

		chart.append("svg:line")
			.attr("x1",x(count))
			.attr("x2",x(count))
			.attr("y1",y(0))
			.attr("y2",y(max))
			.attr("stroke","#000");
		chart.append("svg:line")
			.attr("x1",x(0))
			.attr("x2",x(count))
			.attr("y1",y(max))
			.attr("y2",y(max))
			.attr("stroke","#000")
			.attr("transform","translate(0,-1)");

		if (max > 0) {
			svg.append("svg:text")
				.attr("x",x(count)+5)
				.attr("y",10)
				.style("text-anchor","right")
				.text(max);
		} else {
			svg.append("svg:text")
				.attr("x",(width/2)+10)
				.attr("y",20)
				.style("text-anchor","right")
				.text("No data");
		}
	}
}
