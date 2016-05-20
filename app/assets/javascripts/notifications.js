$(document).ready(function() {

	$(".deleteNotification").on('click', function() {
		var notificationID = $(this).attr('id');
		$.ajax ({
			type: 'DELETE',
			url: '/notifications/' + notificationID,
			data: {notification_id: notificationID},
			success: function(data){}
		})
	});
});