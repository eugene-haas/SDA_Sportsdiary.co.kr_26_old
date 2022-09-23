var addInput = function ($el) {
  if ($el.find("option:selected").val() === "add") {
    var packet = {};
    var ajaxUrl = "/ajax/contest_event/ajax_event_add_input.asp"
    var code = prompt("값을 입력해주세요.");
    packet.cType = $el.find("option:selected").data("cType");
    packet.code = code;
    var data = JSON.stringify(packet);
    // console.log(data)
    if (code) {
      $.ajax({
        url: ajaxUrl,
        type: 'POST',
        data: "req=" + data,
        success: function(returnData) {
          returnData = JSON.stringify(returnData);
          if (!returnData.errorCode) {
            returnIdx = returnData.returnIdx;
            // $("#" + type).append("<option value='' data-game-area-idx="+ returnIdx +">"+ value +"</option>");
            alert("생성완료");
            location.reload();
          } else {
            alert("등록하는데 오류가 있습니다.");
          }
        },
        error: function (xhr, status, error) {
        }
      });
    } else {
      alert("추가생성할 값을 입력해주세요.");
      $("#courseLength option:eq(0)").prop("selected", true);
    }
  }
}


var accessEvent = function (mode, eventIdx) {
  var packet = {};
  var ajaxUrl = "/ajax/contest_event/ajax_event_access.asp"
  packet.mode = mode
  packet.titleIdx = $("#infoList").data("titleIdx");
  packet.eventIdx = eventIdx;
  packet.eventType = $("#eventType option:selected").data("code");
  packet.courseLength = $("#courseLength option:selected").data("code");
  packet.eventDetailType = $("#eventDetailType option:selected").data("code");
  packet.groupType = $("#groupType option:selected").data("code");
  packet.gender = $("#gender option:selected").data("code");
  packet.eventDate = $("#eventDate").val();
  packet.ratingCategory = $("#ratingCategory option:selected").data("code");
  packet.minPlayer = $("#minPlayer option:selected").data("code");
  packet.maxPlayer = $("#maxPlayer option:selected").data("code");
  packet.memberLimit = $("#memberLimit option:selected").data("code");
  packet.entryFee = $("#entryFee").val();
  // console.log(packet);
  // return;
  var data = JSON.stringify(packet);

  //
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      var alertText = ""
      if (mode === "insert") {
        alert("종목입력완료");
        $("#infoList").html(retDATA);
      } else if (mode === "update" ) {
        alert("종목정보 수정완료");
        $("#infoList").html(retDATA);
      } else if (mode === "delete") {
        alert("종목삭제완료");
        location.reload();
      }
    },
    error: function (xhr, status, error) {
    }
  });
}

var selectEvent = function ($el, eventIdx) {
  var packet = {};
  var ajaxUrl = "/contest/event/info_input.asp"
  packet.eventIdx = eventIdx;
  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      $("#inputForm").html(retDATA);
      bindDatetimepicker(); // common.js 에 있음
      $(".event_row").removeClass("success");
      $el.addClass("success");
    },
    error: function (xhr, status, error) {
    }
  });
}

var viewApplyList = function () {
  
}
