var REPORTS = {
	create: function(options) {
		switch (options.name) {
			case "horse_workloads" :
				this.horse_workloads(options);
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
	}
}
