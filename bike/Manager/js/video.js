
var selectVideo = function (videoIdx, titleIdx, $el) {
  var packet = {};
  var ajaxUrl = "info_input.asp"
  packet.titleIdx = titleIdx;
  packet.videoIdx = videoIdx;
  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      $("#inputForm").html(retDATA);
      $(".title_row").removeClass("success");
      $el.addClass("success");
    },
    error: function (xhr, status, error) {
    }
  });
}

var accessVideo = function (mode, titleIdx, videoIdx) {
  var packet = {};
  var ajaxUrl = "/ajax/board/video/ajax_video_access.asp"
  packet.mode = mode;
  packet.videoIdx = videoIdx;
  packet.titleIdx = titleIdx;
  packet.contents = $("#contents").val();
  packet.contentsTitle = $("#contentsTitle").val();
  packet.eventIdx = $("#eventIdx option:selected").val();
  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      $("#infoList").html(retDATA);
    },
    error: function (xhr, status, error) {
    }
  });

}

var changeVideoState = function (videoIdx) {
  var packet = {};
  var ajaxUrl = "/ajax/board/video/ajax_video_state_change.asp"
  var switchId = $("#openState" + videoIdx);
  packet.videoIdx = videoIdx;
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


var searchVideo = function () {
  var packet = {};
  var ajaxUrl = "info_list.asp"
  packet.sContents = $("#sContents").val();
  packet.sContentsTitle = $("#sContentsTitle").val();
  packet.sEventIdx = $("#sEventIdx option:selected").val();

  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      $("#infoList").html(retDATA);
    },
    error: function (xhr, status, error) {
    }
  });

}


var selectTitleYear = function () {
  var packet = {};
  var ajaxUrl = "info_search.asp"
  packet.selectedYear = $("#titleYear option:selected").val();

  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      $("#infoSearch").html(retDATA);
    },
    error: function (xhr, status, error) {
    }
  });
}

var searchTitle = function () {
  var packet = {};
  var ajaxUrl = "info_list.asp"
  packet.selectedYear = $("#titleYear option:selected").val();
  packet.selectedTitle = $("#titleList option:selected").val();

  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function (retDATA) {
      $("#infoList").html(retDATA);
    },
    error: function (xhr, status, error) {
    }
  });

}
