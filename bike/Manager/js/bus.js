function on_select_title(this_is){
  var strAjaxUrl="/ajax/bus/ajax_title_to_location.asp?tidx="+this_is.value;
  var retDATA="";
   $.ajax({
     type: 'GET',
     url: strAjaxUrl,
     dataType: 'html',
     success: function(retDATA) {
      if(retDATA)
        {
          document.getElementById("location_div").innerHTML =retDATA;
        }
     }
   }); //close $.ajax(
}

var changeOpenState = function (openType, refundIdx, paymentIdx) {
  var packet = {};
  var ajaxUrl = "/ajax/bus/ajax_busrefund_change_openState.asp"
  var switchId = $("#" + openType + refundIdx);
  packet.refundIdx = refundIdx;
  packet.paymentIdx = paymentIdx;
  packet.openType = openType;
  packet.openState = switchId.data("openState");
  // console.log(packet)
  // return
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

var busSearch = function () {
  var packet = {};
  var sUrl = "info.asp"
  packet.titleIdx = $("#gametitleidx").val();
  packet.busidx = $("#busidx").val();
  packet.searchtxt = $("#searchtxt").val();

  // console.log(packet);
  // return;
  var data = JSON.stringify(packet);

  document.frm.method="post";
  document.frm.action=sUrl;
  document.frm.req.value=data;
  document.frm.submit();
}

var selectTitle = function (busidx, $el) {
  var packet = {};
  var ajaxUrl = "/bus/info_input.asp"
  packet.busidx = busidx;
  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      $("#inputForm").html(retDATA);
      bindDatetimepicker(); // common.js 에 있음
      $(".title_row").removeClass("success");
      $el.addClass("success");
    },
    error: function (xhr, status, error) {
    }
  });
}

var accessBus = function (mode, busIdx) {
  var packet = {};
  var ajaxUrl = "/ajax/bus/ajax_bus_access.asp"
  packet.mode = mode
  packet.busIdx = busIdx;
  packet.titleIdx = $("#titleIdx").val();
  packet.StartLocation = $("#StartLocation").val();
  packet.Destination = $("#Destination").val();
  packet.StartDate = $("#StartDate").val();
  packet.StartTime = $("#StartTime").val();
  packet.BusMemberLimit = $("#BusMemberLimit").val();
  packet.BusFare = $("#BusFare").val();
  var data = JSON.stringify(packet);
  console.log(data);
  //
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      var alertText = ""
      if (mode === "insert") {
        alert("버스입력완료");
        $("#infoList").html(retDATA);
      } else if (mode === "update" ) {
        alert("버스정보 수정완료");
        $("#infoList").html(retDATA);
      } else if (mode === "delete") {
        alert("버스삭제완료");
        location.reload();
      }
    },
    error: function (xhr, status, error) {
    }
  });
}
