
var addTooltip = function() {
	$('[data-toggle="tooltip"]').tooltip();
}

var addPopover = function () {
	var url = window.location.pathname;
	var url_components = url.split('/');
	var page = url_components[url_components.length -1];
	if (page === 'projects' || page === 'projects_to_enroll') {
  		loadDocumentsDetails();
  	}
};
var columns =  [
    { data: 'name', orderable: false, className: "noSort" },
    { data: 'students' },
    { data: 'duration' },
    { data: 'description', orderable: false, className: "noSort" },
    { data: 'teacher', orderable: false, className: "noSort" },
    { data: 'actions', orderable: false, className: "noSort" }
];
$(document).ready(function() {	
    var c = {};
	var teacher_id = $(".teacherProjects").data('teacher-id');
	$('.diploma_projects').DataTable({
	  ajax: $('.diploma_projects').data('source'),
	  pagingType: 'full_numbers',
	  processing: true,
	  serverSide: true,
	  pageLength: 10,
  	  bFilter: false, 
	  bInfo: false,
	  ordering: false,
	  lengthMenu: [[10, 20, 30, -1], [10, 20, 30, 'All']],
	  columns: [
        { data: 'name' },
        { data: 'students' },
        { data: 'duration' },
        { data: 'description' },
        { data: 'documentation' },
        { data: 'actions' }]
	});

	$(".reloadAjaxProjects").on('click', function() {
		console.log(document.getElementsByName("diploma[diploma_name]")[0].value)
		$(".allDiplomaProjects").DataTable().ajax.reload();
		setTimeout(addPopover, 500);
		setTimeout(addTooltip, 500);
	})

	$(".resetFilters").on('click', function() {
		$('select').val('');
		$(".allDiplomaProjects").DataTable().ajax.reload();
		setTimeout(addPopover, 500);
		setTimeout(addTooltip, 500);

	})

	var table = $(".allDiplomaProjects").DataTable({
  		retrieve: true,
	  	ajax: {
	  		url: $('.allDiplomaProjects').data('source'),
	  		type: 'GET',
	  		data: function ( d ) {
         		return $.extend( {}, d, {
		  			diploma: {
			  			'diploma_name': document.getElementsByName("diploma[diploma_name]")[0].value,
			  			'diploma_max_students': document.getElementsByName("diploma[diploma_max_students]")[0].value,
			  			'diploma_duration': document.getElementsByName("diploma[diploma_duration]")[0].value,
			  			'diploma_teacher': document.getElementsByName("diploma[diploma_teacher]")[0].value,
			  			'diploma_time_span': document.getElementsByName("diploma[diploma_time_span]")[0].value
			  		}
			  	});
	  		}
	  	},
	  	pagingType: 'full_numbers',
	  	processing: true,
	  	serverSide: true,
	 	pageLength: 8,
	  	searching: false,
	  	lengthMenu: [[8, 16, 24, -1], [8, 16, 24, 'All']],
	  	columns: columns,
    	"createdRow": function( row, data, dataIndex ) {
	     	$(row).attr('id', data.id);
	     	$(row).attr('class', 'diplomaProjects');
	  	}   
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
		$.each(diff, function(index, value) {
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

	setTimeout(addTooltip, 500);
	setTimeout(addPopover, 500);

	$(document).on('click',".paginate_button a", function(){
		setTimeout(addTooltip, 500);
	});

	$(document).on('click', '.enrollProject', function(event){
		event.stopPropagation();
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

	$(document).on('click', '.submitEnrollProject', function(event){
		event.stopPropagation();
		var teacher_id = $(this).data('teacher-id');
		var project_id = $(this).data('project-id');
		var enroll_id = $(this).data('enroll-id');

		$.ajax ({
			type: 'POST',
			url: '/diploma_projects/' + project_id + '/submit_enroll',
			data: {enroll_id: enroll_id},
			success: function(data) {
				table.ajax.reload();
				setTimeout(addTooltip, 500);
			}
		});
	});

	$(document).on('click', ".allDiplomaProjects tbody .viewDetails", function() {
		var projectID = $(this).data('details-id');
		$.ajax ({
			type: 'get',
			url: '/diploma_projects/' + projectID + '/diploma_project_modal',
			data: {diploma_project_id: projectID},
			success: function(data){
        		$('#projectModal').html(data).modal({show: true});
        	}
		})
	});


	$(document).on('click', ".diploma_projects tbody .showModalDoc", function() {
		var projectID = $(this).data('project-id');
		$.ajax ({
			type: 'get',
			url: '/diploma_projects/' + projectID + '/show_upload_modal',
			data: {diploma_project_id: projectID},
			success: function(data){
        		$('#showUploadModal').html(data).modal({show: true});
        	}
		})
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