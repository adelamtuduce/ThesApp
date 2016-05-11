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

});