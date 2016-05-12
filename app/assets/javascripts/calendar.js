var updateEvent;

$(document).ready(function() {
  var todayDate = new Date();
  todayDate.setHours(0,0,0,0);

  $('#calendar').fullCalendar({
    editable: false,
    slotEventOverlap: false,
    monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
    monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
    dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    columnFormat: {
      month: 'dddd',
      week: 'ddd d',
      day: 'ddd'
    },
    buttonText: {
      today: 'Today',
      month: 'month',
      week: 'week',
      day: 'day'
    },
    minTime: "08:00:00",
    maxTime: "17:00:00",
    header: {
      left: 'prev,next today',
      center: 'title',
      right: ''
    },
    firstDay: 1,
    //this section is triggered when the event cell it's clicked
    selectable: true,
    selectHelper: true,
    disableResizing:true,
    select: function(start, end) {
      var student_id, teacher_id;
      student_id = $("#student_id").text();
      teacher_id = $("#teacher_id").text();
      var eventData;
      //this validates that the user must insert a name in the input
      if (student_id && teacher_id) {
        eventData = {
          title: "Reserved",
          start: start.format("YYYY-MM-DD h:mm:ss"),
          end: end.format("YYYY-MM-DD h:mm:ss"),
          student_id: student_id,
          teacher_id: teacher_id
        };
        var overlap = $('#calendar').fullCalendar('clientEvents', function(ev) {
            if( ev == event) {
                return false;
            }
            var estart = new Date(ev.start);
            var eend = new Date(ev.end);

            return (
                ( Math.round(start) > Math.round(estart) && Math.round(start) < Math.round(eend) )
                ||
                ( Math.round(end) > Math.round(estart) && Math.round(end) < Math.round(eend) )
                ||
                ( Math.round(start) < Math.round(estart) && Math.round(end) > Math.round(eend) )
            );
        });
        if (overlap.length){
            alert("You already have a meeting in the selected time interval! Please select another time interval!");
            $("#calendar").fullCalendar("unselect");
          return
        }
        //here i validate that the user can't create an event before today
        if (eventData.start < moment(todayDate).format('YYYY-MM-DD')) {
          alert("You can't select a past date!");
          $("#calendar").fullCalendar("unselect");
          return
        }
        //if everything it's ok, then the event is saved in database with ajax
        console.log(eventData)
        $.ajax({
          url: "/events",
          type: "POST",
          data: eventData,
          dataType: 'json',
          success: function(json) {
            alert(json.msg);
            // $("#calendar").fullCalendar("renderEvent", eventData, true);
            $("#calendar").fullCalendar("refetchEvents");
          }
        });
      }
      $("#calendar").fullCalendar("unselect");
    },  
    eventClick: function(calEvent, jsEvent, view) {

        alert('Event: ' + calEvent.title);
        alert('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);
        alert('View: ' + view.name);

        // change the border color just for fun
        $(this).css('border-color', 'red');

    },
    eventDrop: function(event,dayDelta,minuteDelta,allDay,revertFunc) {
        var event_id = event.id;
        var start, end;
        url = "/events/" + event_id;
        var data = {
            start: event._start.format("YYYY-MM-DD h:mm:ss"),
            end: event._end.format("YYYY-MM-DD h:mm:ss"),
            id: event_id
        }
        $.ajax({
          url: url,
          type: "PUT",
          data: data,
          dataType: 'json',
          success: function(data) {
            // $('#calendar').fullCalendar('removeEvents',event_id);
            // $("#calendar").fullCalendar("refetchEvents");
          }
        });
    },
    eventDragStop: function( event, jsEvent, ui, view, removeEvents ) {
    // This condition makes it easier to test if the event is over the trash can using Jquery
    $('.fc-toolbar').on('mouseover', '.deleteEvent', function(){
      $('#calendar').fullCalendar('removeEvents', event.id);
      $.ajax({
          url: '/events/' + event.id,
          type: 'DELETE',
          data: {event_id: event.id},
          success: function(data) {
              $("#calendar").fullCalendar("refetchEvents");
            }
        });
      })
    },
    defaultView: 'agendaWeek',
    allDaySlot: false,
    height: 300,
    slotMinutes: 30,
    timezone: 'local',
    eventSources: [
      {
        url: '/events',
        backgroundColor: '#daeeff',   // an option!
        textColor: 'black',
        editable: true 
      }
    ],
    timeFormat: 'h t',
    dragOpacity: "0.5"
  });
  $("#calendar").find('.fc-toolbar').append('<i class="fa fa-trash fa-2 pull-right deleteEvent" data-toggle="tooltip" data-placement="top" title="Drag Meeting over to delete" aria-hidden="true"></i>')
});
