var sendText = function (parentInfoIdx, userName) {
  var packet = {};
  var ajaxUrl = "/ajax/apply/parent/ajax_send_text.asp"
  packet.parentInfoIdx = parentInfoIdx;
  packet.userName = userName;
  var data = JSON.stringify(packet);
  if (confirm("문자를 발송하시겠습니까?")) {
    $.ajax({
      url: ajaxUrl,
      type: 'POST',
      data: "req=" + data,
      success: function(retDATA) {
        alert("문자가 발송됐습니다.");
      },
      error: function (xhr, status, error) {
      }
    });
  }

}

var searchParentList = function () {
  var packet = {};
  var ajaxUrl = "info_list.asp"
  packet.titleIdx      = $("#title option:selected").val();
  packet.sdate         = $("#sdate").val();
  packet.edate         = $("#edate").val();
  packet.parentAgreeYN = $("#parentAgreeYN option:selected").val();
  packet.searchType    = $("#searchType option:selected").val();
  packet.searchText    = $("#searchText").val();
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
