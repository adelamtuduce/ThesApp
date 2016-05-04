var updateEvent;

$(document).ready(function() {
  var todayDate = new Date();
  todayDate.setHours(0,0,0,0);

  $('#calendar').fullCalendar({
    editable: false,
    slotEventOverlap: false,
    monthNames: ['Ianuarie', 'Februarie', 'Martie', 'Aprilie', 'Mai', 'Iunie', 'Iulie', 'August', 'Septembrie', 'Octombrie', 'Noiembrie', 'Decembrie'],
    monthNamesShort: ['Ian', 'Feb', 'Mar', 'Apr', 'Mai', 'Iun', 'Iul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    dayNames: ['Duminica', 'Luni', 'Marti', 'Miercuri', 'Joi', 'Vineri', 'Sambata'],
    dayNamesShort: ['Dum', 'Lun', 'Mar', 'Mie', 'Joi', 'Vin', 'Sam'],
    columnFormat: {
      month: 'dddd',
      week: 'ddd d',
      day: 'ddd'
    },
    buttonText: {
      today: 'Azi',
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
    select: function(start, end) {
      var student_id, teacher_id;
      student_id = $("#student_id").text();
      teacher_id = $("#teacher_id").text();
      var eventData;
      //this validates that the user must insert a name in the input
      if (student_id && teacher_id) {
        eventData = {
          title: "Rezervat",
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
            alert("Exista o intalnire care se suprapune cu intervalul selectat. Alege un alt interval.");
            $("#calendar").fullCalendar("unselect");
          return
        }
        //here i validate that the user can't create an event before today
        if (eventData.start < moment(todayDate).format('YYYY-MM-DD')) {
          alert("Nu poti selecta o data din trecut.");
          $("#calendar").fullCalendar("unselect");
          return
        }
        //if everything it's ok, then the event is saved in database with ajax
        console.log(eventData)
        $.ajax({
          url: "events",
          type: "POST",
          data: eventData,
          dataType: 'json',
          success: function(json) {
            alert(json.msg);
            $("#calendar").fullCalendar("renderEvent", eventData, true);
            $("#calendar").fullCalendar("refetchEvents");
          }
        });
      }
      $("#calendar").fullCalendar("unselect");
    },  
    // eventClick: function( event, jsEvent, view ) {
    //     console.log("AAAAAAAAAAAAAAAAAAAAAAAAA")
    // var event_id = event.id;
    // var delete_event = confirm("Esti sigur ca vrei sa stergi aceasta intalnire?");
    // if(delete_event === true)
    //     url = "events/" + event_id
    //     $.ajax({
    //       url: url,
    //       type: "DELETE",
    //       data: { id: event_id },
    //       dataType: 'json',
    //       success: function(data) {
    //         $('#calendar').fullCalendar('removeEvents',event_id);
    //         // $("#calendar").fullCalendar("refetchEvents");
    //       }
    //     });
    // },
    // eventDragStop: function( event, jsEvent, view ) {
    //     var event_id = event.id;
    //     var start, end;
    //     console.log(event._start)
    //     console.log(jsEvent)
    //     console.log(view)
    //     url = "events/" + event_id;
    //     var data = {
    //         start: event._start.format("YYYY-MM-DD h:mm:ss"),
    //         end: event._end.format("YYYY-MM-DD h:mm:ss"),
    //         id: event_id
    //     }
    //     $.ajax({
    //       url: url,
    //       type: "PUT",
    //       data: data,
    //       dataType: 'json',
    //       success: function(data) {
    //         // $('#calendar').fullCalendar('removeEvents',event_id);
    //         // $("#calendar").fullCalendar("refetchEvents");
    //       }
    //     });
    // },
    eventDragStop: function( event, jsEvent, ui, view, removeEvents ) {
    // This condition makes it easier to test if the event is over the trash can using Jquery
    if($('#deleteEvent').is(':hover')){
        // Confirmation popup
        $.SmartMessageBox({
            title : "Delete Event?",
            content : 'Are you sure you want to remove this event from the calender?',
            buttons : '[No][Yes]'
        }, function(ButtonPressed) {
            if (ButtonPressed === "Yes") {

                // You can change the URL and other details to your liking.
                // On success a small box notification will fire
                $.ajax({
                    url: '/events/' + event.id,
                    type: 'DELETE',
                    success: function(request) {
                        $.smallBox({
                            title : "Deleting Event",
                            content : "Event Deleted",
                            color : "#659265",
                            iconSmall : "fa fa-check fa-2x fadeInRight animated",
                            timeout : 4000
                        });
                        $('#calendar').fullCalendar('removeEvents', event.id);
                      }
                  });
                }
              });
        }
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
  $("#calendar").find('.fc-toolbar').append('<i class="fa fa-trash fa-3 pull-right deleteEvent" aria-hidden="true"></i>')
});