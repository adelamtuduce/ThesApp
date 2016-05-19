// reset upload file field
window.reset = function (e) {
  document.getElementById("uploadForm").reset();
  $('.uploadHr').addClass('hidden');
  $(".documentFileName").text('');
  $(".noSelected").removeClass('hidden');
  $(".selectedFile").addClass('hidden');
  $(".uploadImage").addClass('hidden');
  $(".startUpload").addClass('hidden');
  $(".cancelButton").addClass('hidden');
};

var loadDocumentsDetails = function() {
  var url = window.location.pathname;
  var url_components = url.split('/');
  var page = url_components[url_components.length -1];
  $.ajax({
    type: 'GET',
    url: '/diploma_projects/retrieve_documentations',
    data: {},
    success: function(data) {
      var url, name, type, html_content, id, label, delete_url;
      label = "<span class='label label-info fileName'>Download</span>"
      $.each(data, function(index, value) {
        html = '';
        id = value.id;
        if (value.document_data.length > 0) {
          html_content = "<div class='col-md-12'><table class='table'>";
          html_content = html_content + "<th style='text-align:left; border-top:none;'>Type</th><th style='border-top:none;'>Name</th><th style='border-top:none;'>Download</th>"
          $.each(value.document_data, function(i, v) {
            url = v.download_url;
            name = v.document_name;
            type = identifyFileType(v.file_type);
            html_content = html_content + "<tr>" + "<td>" + type + "</td>";
            html_content = html_content + "<td class='fileName'>" + name.substr(1,6) + "..." + "</td>";  
            if (page === 'projects') {
              html_content = html_content + "<td> <a href=" + url + " class='fileName'>" + label + "</a></br>" + delete_url + "</td></tr>"
            } else {
              html_content = html_content + "<td> <a href=" + url + " class='fileName'>" + label + "</a></td></tr>"
            }
          })
          html_content = html_content + "</table></div>"
          $("#showDiplomaDetails_" + id).popover({trigger: 'click', title: "Uploaded documents", html: true, content: html_content, placement: 'top'});
        } else {
          html_content = 'There are no documents uploaded for this project.';
          $("#showDiplomaDetails_" + id).popover({trigger: 'click', title: "Uploaded documents", html: true, content: html_content, placement: 'top'});
        }  
      })
      
    }
  });
};
$(document).ready(function() {
  $(".fileupload").fileupload({
    replaceFileInput: false,
      send: function(e, data) {
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
        $('.btn-file').addClass('hidden');
        // display name of uploaded file
        $('.uploadHr').removeClass('hidden');
        $(".documentFileName").text(data.files[0].name);
        $(".noSelected").addClass('hidden');
        $(".selectedFile").removeClass('hidden');
        $(".uploadImage").removeClass('hidden');
        $(".startUpload").removeClass('hidden');
        $(".cancelButton").removeClass('hidden');

        data.context = $(".startUpload").click(function() {
        });
    },
    progress: function (e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      $('#js-file-upload-progress').css('width', progress + '%');
    },
    success: function (e, data) {
    }
  });
});
