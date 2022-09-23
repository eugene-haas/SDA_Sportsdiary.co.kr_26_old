
// 이미지 미리보기
$(function() {
  $("#inputForm").on('change','#uploadImage', function() {
      readURL(this);
  });

  $("#infoList").on("click", "tr td", function () {
      var isSwitch = $(this).data("switch") === "Y";
      if (!isSwitch) {
        var titleIdx = $(this).parent("tr").data("titleIdx");
        var imageIdx = $(this).parent("tr").data("imageIdx");
        selectImage(imageIdx, titleIdx, $(this).parent("tr"));
      }
  });

});

function readURL(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('#imagePreview').attr('src', e.target.result);
    }

    reader.readAsDataURL(input.files[0]);
  }
}




var uploadImage = function (mode, titleIdx, imageIdx) {
  var packet = {};
  var ajaxUrl = "/ajax/board/image/ajax_image_file_upload.asp"
  var contentsTitle = $("#contentsTitle").val();
  var formData = new FormData();
  var logoYN = "N"
  if ($("#logoYN").prop("checked")) logoYN = "Y";
  var page = $("#paging").data("currentPage");
  var uploadFile = $("#uploadImage")[0].files[0];
  var isUpdateFile;
  isUpdateFile = uploadFile ? "Y" : "N";


  formData.append("mode", mode);
  formData.append("titleIdx", titleIdx);
  formData.append("isUpdateFile", isUpdateFile);
  formData.append("contentsTitle", contentsTitle);
  formData.append("uploadIMG", $("#uploadImage")[0].files[0]);
  formData.append("logoYN", logoYN);
  formData.append("imageIdx", imageIdx);
  formData.append("PN", page);

  // for (var pair of formData.entries()) {
  //     console.log(pair[0]+ ', ' + pair[1]);
  // }
  // return;

  if (!$("#uploadImage").val() && mode !== "update") {
    alert("파일을 등록해주세요");
    return;
  } else {
    $.ajax({
      url: ajaxUrl,
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(retDATA) {
        alert("저장되었습니다.");
        $("#infoList").html(retDATA);
      },
      error: function (xhr, status, error) {
      }
    });
  }
}

var deleteImage = function (titleIdx, imageIdx) {
  var packet = {};
  packet.titleIdx = titleIdx;
  packet.imageIdx = imageIdx;
  var ajaxUrl = "/ajax/board/image/ajax_image_file_delete.asp";
  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function (retDATA) {
      $("#infoList").html(retDATA);
      alert("삭제되었습니다.");
    },
    error: function (xhr, status, error) {
    }
  });
}


var selectImage = function (imageIdx, titleIdx, $el) {
  var packet = {};
  var ajaxUrl = "info_input.asp"
  packet.titleIdx = titleIdx;
  packet.imageIdx = imageIdx;
  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function (retDATA) {
      $("#inputForm").html(retDATA);
      $(".title_row").removeClass("success");
      $el.addClass("success");
    },
    error: function (xhr, status, error) {
    }
  });
}

var changeImageState = function (titleIdx, imageIdx) {
  var packet = {};
  var ajaxUrl = "/ajax/board/image/ajax_image_state_change.asp"
  var switchId = $("#openState" + imageIdx);
  packet.titleIdx = titleIdx;
  packet.imageIdx = imageIdx;
  packet.openState = switchId.data("openState");
  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      retDATA = JSON.parse(retDATA);
      var changeState = retDATA.changeState;
      switchId.data("openState", changeState);
    },
    error: function (xhr, status, error) {
    }
  });

}
