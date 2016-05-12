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
});