var createScheduler = function(student, teacher) {
	scheduler.config.xml_date="%Y-%m-%d %H:%i";
    scheduler.config.first_hour = 8;
    scheduler.config.last_hour = 18;
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

    scheduler.init("scheduler_here");
    scheduler.load("/events?student_id=" + student + "&teacher_id=" + teacher, "json");
    var dp = new dataProcessor("/events/db_action?student_id=" + student + "&teacher_id=" + teacher);
    dp.init(scheduler);
    dp.setTransactionMode("GET", false);
}
