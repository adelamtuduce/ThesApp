$(document).ready(function() {	
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

	var addTooltip = function() {
		$('[data-toggle="tooltip"]').tooltip();
	}

	setTimeout(addTooltip, 500);

	$(document).on('click',".paginate_button a", function(){
		console.log("AAAAAAAAAAAAAAAA")
		setTimeout(addTooltip, 500);
	});

	$(document).on('click', ".deleteProject", function() {
		console.log("AAAAAAAAAA")
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