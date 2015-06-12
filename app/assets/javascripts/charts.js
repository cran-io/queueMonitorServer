function line_chart(data, chart_id, axis){
  nv.addGraph(function () {
    var chart = nv.models.lineChart()
    .showLegend(true)

    .margin({top: 30, right: 40, bottom: 50, left: 40})
    .tooltipContent(function (key, y, e, graph) {
      return '<p>' + key + '</p>' + '<p>' + e + '% - ' + y + '</p>'
    });
    
    chart.xAxis.tickFormat(function (d) {
      if(axis == 'hour')
        return d3.time.format('%d/%m/%y %H:%M')(new Date(d))
      else
        return d3.time.format('%d/%m/%y')(new Date(d))
    });

    d3.select('#'+ chart_id +' svg')
      .datum(data.chart_data)
      .transition().duration(500)
      .call(chart)
      .each('start', function() {
      setTimeout(function() {
        d3.selectAll('#'+ chart_id +' *').each(function() {
          if(this.__transition__)
            this.__transition__.duration = 1;
        })
      }, 0)
    });

    nv.utils.windowResize(chart.update);
    return chart;
  });
}