$(document).ready(function() {	
	var teacher_id = $(".enrollRequests").data('teacher-id');
	var addDataTable = function(element) {
		element.DataTable({
		  ajax: element.data('source'),
		  pagingType: 'full_numbers',
		  processing: true,
		  serverSide: true,
		  pageLength: 10,
		  bFilter: false, 
		  bInfo: false,
		  ordering: false,
		  lengthMenu: [[10, 20, 30, -1], [10, 20, 30, 'All']],
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

	$('.studentsTable').DataTable({
		  ajax: $('.studentsTable').data('source'),
		  pagingType: 'full_numbers',
		  processing: true,
		  serverSide: true,
		  pageLength: 10,
		  bFilter: false, 
		  bInfo: false,
		  "ordering": false,
		  lengthMenu: [[10, 20, 30, -1], [10, 20, 30, 'All']],
		  columns: [
	        { data: 'name', "orderable": false },
	        { data: 'code', "orderable": false },
	        { data: 'actions', "orderable": false }
	        ]
		});
	$('.teachersTable').DataTable({
		  ajax: $('.teachersTable').data('source'),
		  pagingType: 'full_numbers',
		  processing: true,
		  serverSide: true,
		  pageLength: 10,
		  bFilter: false, 
		  bInfo: false,
		  "ordering": false,
		  lengthMenu: [[10, 20, 30, -1], [10, 20, 30, 'All']],
		  columns: [
	        { data: 'name', "orderable": false },
	        { data: 'code', "orderable": false },
	        { data: 'actions', "orderable": false }
	        ]
		});
});