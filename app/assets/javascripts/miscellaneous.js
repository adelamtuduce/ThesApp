$(document).ready(function() {
	
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