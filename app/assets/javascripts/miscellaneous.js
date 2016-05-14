var identifyFileType = function(type) {
	var icon;
	switch(type) {
	    case 'word':
	        icon = '<i class="fa fa-file-word-o fileType" aria-hidden="true"></i>';
	        break;
	    case 'pdf':
	        icon = '<i class="fa fa-file-pdf-o fileType" aria-hidden="true"></i>';
	        break;
	    default:
	        icon = '<i class="fa fa-file-text fileType" aria-hidden="true"></i>';
	}
	return icon;
}


$(document).ready(function() {

	$("#start-date").datetimepicker().show('true');
	$("#end-date").datetimepicker();
	
	$('.toggleStatus').on('click', function() {
		var statusID = $(this).attr('id');

		$.ajax ({
			type: 'POST',
			url: '/users/toggle_selection',
			data: { selection_id: statusID },
			success: function(data) {
				
			}
		})
	});

	$('.toggleNotifications').on('click', function() {
		var infoId = $(this).attr('id').replace('notif_', '');

		$.ajax ({
			type: 'POST',
			url: '/personal_informations/' + infoId + '/toggle_notifications',
			data: { information_id: infoId },
			success: function(data) {
				
			}
		})
	});

	$('.toggleEmails').on('click', function() {
		var infoId = $(this).attr('id').replace('email_', '');

		$.ajax ({
			type: 'POST',
			url: '/personal_informations/' + infoId + '/toggle_emails',
			data: { information_id: infoId },
			success: function(data) {
				
			}
		})
	});
});