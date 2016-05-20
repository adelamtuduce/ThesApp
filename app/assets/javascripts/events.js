var dp = new dataProcessor();
function dhtmlxGridExists(the_id){
    return document.getElementById(the_id) || null;
}

var createScheduler = function(request_id, students, element_id) {
  if(dhtmlxGridExists(element_id)) {
    scheduler.config.xml_date="%Y-%m-%d %H:%i";
      scheduler.config.first_hour = 8;
      scheduler.config.last_hour = 18;
      scheduler.config.collision_limit = 1;
      scheduler.attachEvent("onEventLoading", function(ev){ 
          return scheduler.checkCollision(ev);             
      }); 
      scheduler.attachEvent("onBeforeTooltip",function(){
        return false;
      });
      var block_id = null;
      scheduler.attachEvent("onBeforeViewChange", function(old_mode,old_date,mode,date){
      if(block_id) 
        scheduler.deleteMarkedTimespan(block_id);
          
      var from = scheduler.date[mode + "_start"](new Date(date));
      var to = new Date(Math.min(+new Date(), +scheduler.date.add(from, 1, mode)));
    
      block_id = scheduler.addMarkedTimespan({
        start_date: from, 
        end_date:to, 
        type:"dhx_time_block"
      });
        
      return true;
    });

    // set allowed time - from the current date, and update each minute
    scheduler.config.limit_start = new Date();
    scheduler.config.limit_end = new Date(9999, 1,1);
    setInterval(function(){
       scheduler.config.limit_start = new Date();
    }, 1000*60);

      var student_ids = '';
      scheduler.clearAll();
      scheduler.init(element_id);
      if (students.length > 1) {
        $.each(students, function(index, value){
          student_ids = student_ids + "student_id[]=" + value + '&';
        })
      } else {
        student_ids = student_ids + "student_id[]=" + students + '&';
      }
      dp.serverProcessor = "/events/db_action?" + student_ids + "request_id=" + request_id
      scheduler.load("/events?" + student_ids + "request_id=" + request_id, "json");
      dp.init(scheduler);
      dp.setTransactionMode("GET", false);
    }
}

