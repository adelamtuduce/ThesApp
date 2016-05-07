$(document).ready(function() {	
	var c = {};
	var teacher_id = $(".teacherProjects").data('teacher-id');
	$('.diploma_projects').DataTable({
	  ajax: $('.diploma_projects').data('source'),
	  pagingType: 'full_numbers',
	  processing: true,
	  serverSide: true,
	  pageLength: 8,
	  lengthMenu: [[8, 16, 24, -1], [8, 16, 24, 'All']],
	  columns: [
        { data: 'id' },
        { data: 'name' },
        { data: 'students' },
        { data: 'duration' },
        { data: 'description' },
        { data: 'actions' }
    ]
	});

	var table = $(".allDiplomaProjects").DataTable({
	  ajax: $('.allDiplomaProjects').data('source'),
	  pagingType: 'full_numbers',
	  processing: true,
	  serverSide: true,
	  pageLength: 8,
	  lengthMenu: [[8, 16, 24, -1], [8, 16, 24, 'All']],
	  columns: [
        { data: 'name' },
        { data: 'students' },
        { data: 'duration' },
        { data: 'description' },
        { data: 'teacher' },
        { data: 'actions' }
    ]
	});

	var studentEnrolls = $('.toRequestEnroll').DataTable({
		ajax: $('.toRequestEnroll').data('source'),
		  pagingType: 'full_numbers',
		  processing: true,
		  serverSide: true,
		  pageLength: 8,
		  rowReorder: true,
		  "bSort": false,
		  searching: false,
		  lengthMenu: [[8, 16, 24, -1], [8, 16, 24, 'All']],
		  columns: [
	        { data: 'name' },
	        { data: 'teacher' },
	        { data: 'actions' }
	    ],
	    "createdRow": function( row, data, dataIndex ) {
         	$(row).attr('id', 'row-' + (parseInt(dataIndex)+1).toString());
      	}   
	});

	studentEnrolls.on( 'row-reorder', function ( e, diff, edit ) {
		var ids = []
		console.log(diff)
		$.each(diff, function(index, value) {
			console.log($(value))
			ids.push({priority: value.newPosition + 1, request_id: $(value.node).children().last().find('span').data('enroll-id')});
		})

		$.ajax ({
			url: '/diploma_projects/update_priorities',
			type: 'POST',
			data: {priorities: ids},
			success: function(data) {
				studentEnrolls.ajax.reload();
			}
		});
	});

	var addTooltip = function() {
		$('[data-toggle="tooltip"]').tooltip();
	}

	setTimeout(addTooltip, 500);

	$(document).on('click',".paginate_button a", function(){
		setTimeout(addTooltip, 500);
	});

	$(document).on('click', '.enrollProject', function(){
		var teacher_id = $(this).data('teacher-id');
		var project_id = $(this).data('project-id');

		$.ajax ({
			type: 'POST',
			url: '/diploma_projects/' + project_id + '/enroll',
			data: { teacher_id: teacher_id, project_id: project_id },
			success: function(data) {
				table.ajax.reload();
				setTimeout(addTooltip, 500);
			}
		});
	});

	$(document).on('click', ".deleteProject", function() {
		var projectID = $(this).attr('id');
		$.ajax ({
			url: '/diploma_projects/' + projectID,
			type: 'DELETE',
			data: { id: projectID },
			success: function(data) {
				var table = $('.diploma_projects').DataTable();
				table.ajax.reload();
			}
		});
	});
});