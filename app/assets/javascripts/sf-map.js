$(document).ready(function() {
  var width = 800,
    height = 900;

  var projection = d3.geo.mercator()
    .center([-122.422218291145, 37.7455788136374])
    .scale(1005000)
    .translate([width / 2, height / 2]);

  var path = d3.geo.path()
    .projection(projection);

  var zoom = d3.behavior.zoom()
    .translate([0, 0])
    .scale(1)
    .scaleExtent([1, 8])
    .on("zoom", zoomed);

  var sidebar = d3.select(".map").append("svg")
    .attr("class", "sidebar");

  var dayList = sidebar.append('g')
    .attr("class", "days");

  // need to define height and width here, as opposed to in the css
  var svg = d3.select(".map").append("svg")
    .attr("id", "sfmap")
    .attr("width", width)
    .attr("height", height);

  svg.append("rect")
    .attr("class", "overlay")
    .call(zoom);

  var features = svg.append("g");

  queue()
    .defer(d3.json, "/assets/land_usages_tiles.json")
    .defer(d3.json, "/assets/highroad_tiles.json")
    .defer(d3.json, "/assets/routes.json")
    .await(ready);

  function ready(error, land, highroads, sfj) {
    window.landd = land
    window.road = highroads
    window.sss = sfj
    var vector = features.append("g")
      .attr("class", "vector")
      .call(renderLayer, road, 'highroad')
      .call(renderLayer, landd, "land-usages");
    svg.call(drawRoutes, topojson.feature(sss, sss.objects.street_sweep_routes_all).features);


    drawDayNav();
    attachDayListeners();
  }

  function drawRoutes(g, plotData) {

    var routesContainer = features.append("g")
      .attr("class", "routes")
      .attr("d", path);
    _.each(plotData, function(d, e) {
      var route_path = routesContainer.append("path")
        .attr("class", "route " + d.properties.label)
        .attr("id", d.id)
        .attr("d", path(d.geometry));
    });
  }

  function renderLayer(elem, plotData, name) {
    var container = elem.append("g")
      .attr("class", name);
    _.each(plotData, function(d, e) {
      container.append("path")
        .data(d.features)
        .attr("class", function(d) {
          return d.properties.kind;
        })
        .attr("name", function(d) {
          return d.properties.name;
        })
        .attr("d", path(d));
    });
  }

  function zoomed() {
    features.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
  }


  function drawDayNav() {
    var days_data = [ "Su", "Mo", "Tu", "We", "Th", "Fr", "Sa", "All" ];
    _.each(days_data, function(d, e) {
      dayList.append('circle')
        .datum(d)
        .attr("class", "day " + d)
        .attr('cx', '60')
        .attr('cy', 150 + e * 75)

      dayList.append('text')
        .datum(d)
        .text(d)
        .attr("class", 'day ' + d)
        .attr('x', '60')
        .attr('y', 155 + e * 75)
    });
  }

  function attachDayListeners() {
    var days = dayList.selectAll('.day');
    days.on('mouseenter', function(d) {
      dayList.select('.day.' + d)
        .style('fill', '#4d5863');
    });
    days.on('mouseleave', function(d) {
      dayList.selectAll('circle.day')
        .style('fill', '#363e46');
    });
    days.on('click', function(day) {
      dayList
        .attr("class", 'days ' + day);
      features.select('.routes')
        .attr("class", "routes " + day);
    });
  }

  d3.select(self.frameElement)
    .style("height", "900px")
    .style("border", "none");

});
