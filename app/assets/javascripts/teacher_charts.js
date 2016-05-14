/*global chart $*/
var requestsAll;
var colorPattern = ['#003d66', '#4d004d', '#00ccff'];
$(document).ready(function() {  
  var max;
  var dates = ['x'];
  var theDate = new Date();
  for (var i = 0; i < 7; i++) {
    theDate = new Date(new Date().setDate(new Date().getDate()-i));
    dates.push( theDate.getFullYear()+'-'+(theDate.getMonth()+1)+'-'+theDate.getDate());
  }

  requestsAll = c3.generate({
    bindto: '#requests-all',
    size: {
      height: 250
    },
    data: {
      x: 'x',
      columns: [
        dates,
        ['total', 0, 0, 0, 0, 0, 0, 0, 0],
        ['wishlist', 0, 0, 0, 0, 0, 0, 0, 0],
        ['requests', 0, 0, 0, 0, 0, 0, 0, 0]
      ],
      type: 'bar',
      names: {
        total: 'Total',
        requests: 'Requests',
        wishlist: 'Wishlists'
      }
    },
    axis: {
      x: {
          type: 'timeseries',
          tick: {
              format: '%b %e'
          }
      },
      y: {
        show: true
      }
    },
    color: {
      pattern: colorPattern
    },
    legend: {
      show: true
    }
  });

  $("#js-date-range").popover({
    html : true,
    template: '<div class="popover filter-popover mr20" role="tooltip"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>',
    content: function() {
      $("#start-date").attr("value", startDate);
      $("#end-date").attr("value", endDate);
      return $('#date-range-content').html();
    }
  });
});

var updateCharts = function(data) {
  requestsAll.load({
    json: data,
    keys: {
      value: ['x', 'total', 'wishlist', 'requests']
    }
  });
};
var loadChart = function(){
  var stuff = window.location.pathname.split('/');
  var id = stuff[2];
  var startDate = $('#start-date').val();
  var endDate   = $('#end-date').val();
  var url = '/teachers/' + id + '/retrieve_charts_data';
  $.ajax({
    type: 'get',
    url: url,
    data: {},
    success: function(data) {
      placeCorrectCharts(data);
    }
  });
};

var placeCorrectCharts = function(data) {
  updateCharts(data.result);
  max = data.max;
}
