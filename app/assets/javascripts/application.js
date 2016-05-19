// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.dataTables.min
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require moment
//= require rowReorder.min
//= require turbolinks
//= require jquery-fileupload/basic
//= require chat
//= require columnFilter
//= require bootstrap.min
//= require dhtmlxscheduler
//= require dhtmlxscheduler_limit
//= require dhtmlxscheduler_tooltip
//= require c3
//= require d3
//= require datetimepicker.min
//= require validation
//= require private_pub
//= require toastr
//= require_tree .

$(document).ready(function() {
	toastr.options = {
    "closeButton": true,
    "debug": false,
    "positionClass": "toast-top-right",
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
	}

	});

