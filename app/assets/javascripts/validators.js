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
        	error.insertAfter('.form-group');
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

	$("#edit_info").validate({
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

  $(".upload_avatar").validate({
    rules: {
      "personal_information[avatar]": {
        required: true
      }
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