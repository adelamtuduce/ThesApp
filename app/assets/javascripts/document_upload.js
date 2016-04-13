$(document).ready(function() {
  console.log("ADDDDDDDDDDDDDDDDDDDDD")
  $(".fileupload").fileupload({
    replaceFileInput: false,
      send: function(e, data) {
        console.log("AAAAAAAAAAAAAAAAAa")
        var types = /(\.|\/)(csv)$/i;
        var uploading = true;
        var valid = true;
        $.each(data.files, function(index, value) {
          if(!types.test(value.name)) {
            uploading = false;
          }
          if (value.size === 0) {
            valid = false;
          }
        });
        if (uploading === false) {
          // set_global_message('error', 'File format not supported. Please select a .csv file.');
        }

        if (valid === false) {
          uploading = false;
          // set_global_message('error', 'File is empty. Please choose a valid .csv file.');
        }
        return uploading;
      },
      add: function (e, data) {
        console.log("UUUUUUUUUUUUUUU")
        console.log(data);
        $('.btn-file').addClass('hidden');
        // display name of uploaded file
        $(".show-file").text(data.files[0].name).removeClass('hidden');
        $(".uploadImage").removeClass('hidden');
        $(".startUpload").removeClass('hidden');

        data.context = $(".startUpload").click(function() {
          console.log(data);
          console.log("IIIIIIIIIIIIIIIIIIIIIIIIIIIII")
          data.submit();
          console.log("IIIIIIIIIIIIIIIIIIIIIIIIIIIII")
        });
    },
    progress: function (e, data) {
      console.log("UUUUUUUUUUUUUUUOOOOOOOOOOOOOO")
      var progress = parseInt(data.loaded / data.total * 100, 10);
      $('#js-file-upload-progress').css('width', progress + '%');
    },
    success: function (e, data) {
      console.log("IIIIIIIIIIIIIIIIIIII")
    }
  });
});
