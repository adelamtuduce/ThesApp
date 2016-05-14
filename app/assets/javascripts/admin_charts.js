/*global chart $*/
var allRequests, users, documents, projects;
var adminColorPattern = ['#003d66', '#4d004d', '#00ccff', '#336600'];
$(document).ready(function() {  
  var max;
  var dates = ['x'];
  var theDate = new Date();
  for (var i = 0; i < 7; i++) {
    theDate = new Date(new Date().setDate(new Date().getDate()-i));
    dates.push( theDate.getFullYear()+'-'+(theDate.getMonth()+1)+'-'+theDate.getDate());
  }

  allRequests = c3.generate({
    bindto: '#requests',
    size: {
      height: 250
    },
    data: {
      x: 'x',
      columns: [
        dates,
        ['requests', 0, 0, 0, 0, 0, 0, 0, 0],
        ['approved_requests', 0, 0, 0, 0, 0, 0, 0, 0],
        ['declined_requests', 0, 0, 0, 0, 0, 0, 0, 0],
        ['pending_requests', 0, 0, 0, 0, 0, 0, 0, 0]
      ],
      type: 'bar',
      names: {
        requests: 'Total',
        approved_requests: 'Accepted',
        declined_requests: 'Declined',
        pending_requests: 'Pending'
      }
    },
    bar: {
      width: {
          ratio: 1// this makes bar width 50% of length between ticks
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
      pattern: adminColorPattern
    },
    legend: {
      show: true
    }
  });

  users = c3.generate({
    bindto: '#users',
    size: {
      height: 250
    },
    data: {
      x: 'x',
      columns: [
        dates,
        ['users', 0, 0, 0, 0, 0, 0, 0, 0],
        ['students', 0, 0, 0, 0, 0, 0, 0, 0],
        ['teachers', 0, 0, 0, 0, 0, 0, 0, 0]
      ],
      type: 'bar',
      names: {
        users: 'Total',
        students: 'Students',
        teachers: 'Teachers'
      }
    },
    bar: {
      width: {
          ratio: 0.75// this makes bar width 50% of length between ticks
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
      pattern: adminColorPattern
    },
    legend: {
      show: true
    }
  });

  documents = c3.generate({
    bindto: '#documents',
    size: {
      height: 250
    },
    data: {
      x: 'x',
      columns: [
        dates,
        ['documents', 0, 0, 0, 0, 0, 0, 0, 0]
      ],
      type: 'spline',
      names: {
        documents: 'Documents'
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
      pattern: adminColorPattern
    },
    legend: {
      show: true
    }
  });

  projects = c3.generate({
    bindto: '#projects',
    size: {
      height: 250
    },
    data: {
      x: 'x',
      columns: [
        dates,
        ['projects', 0, 0, 0, 0, 0, 0, 0, 0]
      ],
      type: 'spline',
      names: {
        projects: 'Projects'
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
      pattern: adminColorPattern
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

var updateAdminCharts = function(data) {
  allRequests.load({
    json: data,
    keys: {
      value: ['x', 'requests', 'approved_requests', 'declined_requests', 'pending_requests']
    }
  });

  users.load({
    json: data,
    keys: {
      value: ['x', 'users', 'students', 'teachers']
    }
  });

  documents.load({
    json: data,
    keys: {
      value: ['x', 'documents']
    }
  })

  projects.load({
    json: data,
    keys: {
      value: ['x', 'projects']
    }
  })
};
var loadAdminChart = function(){
  var stuff = window.location.pathname.split('/');
  var id = stuff[2];
  var startDate = $('#start-date').val();
  var endDate   = $('#end-date').val();
  var url = '/users/' + id + '/admin_chart_data';
  $.ajax({
    type: 'get',
    url: url,
    data: {},
    success: function(data) {
      placeCorrectAdminCharts(data);
    }
  });
};

var placeCorrectAdminCharts = function(data) {
  updateAdminCharts(data.result);
  max = data.max;
}
