$(document).ready(function() {	
	var teacher_id = $(".enrollRequests").data('teacher-id');
	var addDataTable = function(element) {
		element.DataTable({
		  ajax: element.data('source'),
		  pagingType: 'full_numbers',
		  processing: true,
		  serverSide: true,
		  pageLength: 8,
		  lengthMenu: [[8, 16, 24, -1], [8, 16, 24, 'All']],
		  columns: [
	        { data: 'student' },
	        { data: 'project' },
	        { data: 'actions' }
	        ]
		});
	}
	addDataTable($('.enrollRequestsTable'));
	addDataTable($('.acceptedEnrollRequestsTable'));

	$(document).on('click', '.acceptRequest', function(event) {
		var clicked = $(this);
		var student_id = $(this).data('student-id');
		var project_id = $(this).data('diploma-id');
		console.log(student_id)
		console.log(project_id)
		$.ajax ({
			type: 'GET',
			url: '/teachers/' + teacher_id + '/accept_enrollment',
			data: { student_id: student_id, project_id: project_id },
			success: function(data) {
				var table = $('.enrollRequestsTable').DataTable();
				table.ajax.reload();
				var enrollTable = $('.acceptedEnrollRequestsTable').DataTable();
				enrollTable.ajax.reload();
			}
		});
	});
});