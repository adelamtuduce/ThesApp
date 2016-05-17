$(document).ready(function() {

      $("#new_user").validate({

        rules: {
          "user[email]": {
            required: true,
            email: true,
            maxlength: 50,
            minlength: 5
          },
          'user[password]': {
          	required: true,
          	minlength: 8
          }
        },
        errorPlacement: function(error, element) {
        	error.insertAfter('.form-group'); //So i putted it after the .form-group so it will not include to your append/prepend group.
    	}, 

  //       tooltip_options: {
		// 	"user[email]": {placement:'top',html:true},
		// 	"user[password]": {placement:'top',html:true}
		// },
		highlight: function(element) {
			$(element).closest('.form-group').removeClass('has-success has-feedback').addClass('has-error has-feedback');
	        $(element).closest('.form-group').find('i.fa').remove();
	        $(element).closest('.form-group').append('<i class="fa fa-exclamation fa-lg form-control-feedback"></i>');
	    },
	    unhighlight: function(element) {
	    	$(element).closest('.form-group').removeClass('has-error has-feedback').addClass('has-success has-feedback');
	        $(element).closest('.form-group').find('i.fa').remove();
            $(element).closest('.form-group').append('<i class="fa fa-check fa-lg form-control-feedback"></i>');
	    }
    });

	$(".edit_personal_information").validate({
		rules: {
          "personal_information[first_name]": {
            required: true,
            maxlength: 50,
            minlength: 2
          },
          'personal_information[last_name]': {
          	required: true,
            maxlength: 50,
          	minlength: 2
          }
        },
        errorPlacement: function(error, element) {
        	console.log("AAAAAAAAAAAAAAAAAAAAAAAAAA")
        	error.insertAfter('.form-group'); //So i putted it after the .form-group so it will not include to your append/prepend group.
    	}, 

        tooltip_options: {
			"personal_information[first_name]": {placement:'top',html:true},
			"personal_information[last_name]": {placement:'top',html:true}
		},
		highlight: function(element) {
			$(element).closest('.form-group').removeClass('has-success has-feedback').addClass('has-error has-feedback');
	        $(element).closest('.form-group').find('i.fa').remove();
	        $(element).closest('.form-group').append('<i class="fa fa-exclamation fa-lg form-control-feedback"></i>');
	    },
	    unhighlight: function(element) {
	    	$(element).closest('.form-group').removeClass('has-error has-feedback').addClass('has-success has-feedback');
	        $(element).closest('.form-group').find('i.fa').remove();
            $(element).closest('.form-group').append('<i class="fa fa-check fa-lg form-control-feedback"></i>');
	    }
	});

 });