var changeRefundState = function (refundIdx, paymentIdx) {
  var packet = {};
  var ajaxUrl = "/ajax/apply/refund/ajax_refund_state_change.asp"
  var switchId = $("#refundState" + refundIdx);
  packet.refundIdx = refundIdx;
  packet.paymentIdx = paymentIdx;
  packet.openState = switchId.data("openState");
  // console.log(packet);
  // return;
  var data = JSON.stringify(packet);
  if (confirm("환불처리 하시겠습니까?")) {
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
  } else {
    location.reload();
  }
}

var searchRefundList = function () {
  var packet = {};
  var ajaxUrl = "info_list.asp"
  packet.titleIdx = $("#title option:selected").val();
  packet.sdate    = $("#sdate").val();
  packet.edate    = $("#edate").val();
  packet.refundYN = $("#refundYN option:selected").val();
  packet.searchType = $("#searchType option:selected").val();
  packet.searchText = $("#searchText").val();
  // console.log(packet);
  // return;
  var data = JSON.stringify(packet);
  $.ajax({
    url: ajaxUrl,
    type: 'POST',
    data: "req=" + data,
    success: function(retDATA) {
      $("#infoList").html(retDATA);
      console.log(retDATA);
    },
    error: function (xhr, status, error) {
    }
  });
}
