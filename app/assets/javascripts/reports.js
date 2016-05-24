$(document).ready(function() {

	$(".sendReport").on('click', function() {
		var reportClassName = $(this).data('report-type');
		var reportID = $(this).data('report-id');

		$.ajax ({
			type: 'GET',
			url: '/admin/export_to_csv',
			data: {report_id: reportID, report_type: reportClassName}
		})
	})
});