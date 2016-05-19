$(document).ready(function() {	
	$(document).on('click', '.cancelRequest', function(event){
		var studentEnrolls = $('.toRequestEnroll').DataTable();
		console.log($(this).parents('tr'));
		var row = studentEnrolls.row( $(this).parents('tr') );
		var teacher_id = $(this).data('teacher-id');
		var enroll_id = $(this).data('enroll-id');

		$.ajax ({
			type: 'DELETE',
			url: '/enroll_requests/' + enroll_id,
			data: { enroll_request_id: enroll_id},
			success: function(data) {
			    row.remove();
			    studentEnrolls.draw(false);
				var allDiplomas = $(".allDiplomaProjects").DataTable();
				allDiplomas.ajax.reload();
				setTimeout(addTooltip, 500);
			}
		});
	});

	// $(document).on('click', '.overviewPage', function(event){ 
	// 	var enroll_id = $(this).data('enroll-request');
	// 	$.ajax ({
	// 		type: 'GET',
	// 		url: '/enroll_requests/' + enroll_id + '/overview',
	// 		data: { enroll_request_id: enroll_id},
	// 		success: function(data) {
	// 		 //    row.remove();
	// 		 //    studentEnrolls.draw(false);
	// 			// var allDiplomas = $(".allDiplomaProjects").DataTable();
	// 			// allDiplomas.ajax.reload();
	// 			// setTimeout(addTooltip, 500);
	// 		}
	// 	})
	// });

	var url = window.location.pathname;
   	var url_components = url.split('/');
  	var page = url_components[2];
	var requestID = page;
	$.ajax ({
		type: 'GET',
		url: '/enroll_requests/' + requestID + '/display_tabbed_content',
		data: {},
		success: function(data) {
		}
	})

	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
		var studentID = $(this).parent().data('student-id');
		var teacherID = $(this).parent().data('teacher-id');
		console.log(studentID)
		if(studentID != undefined) {
			createScheduler(studentID, teacherID, "scheduler_here_" + studentID);
		} else {
			createScheduler(studentID, teacherID, "scheduler_here");
		}
	});
});