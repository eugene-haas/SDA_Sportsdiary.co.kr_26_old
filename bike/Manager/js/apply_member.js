var searchApplyMember = function () {
  var packet = {};
  var ajaxUrl = "info_list.asp"
  packet.titleIdx        = $("#title option:selected").val();
  packet.sdate           = $("#sdate").val();
  packet.edate           = $("#edate").val();
  packet.searchType      = $("#searchType option:selected").val();
  packet.searchText      = $("#searchText").val();
  packet.gender          = $("#gender option:selected").data("code");
  packet.ratingCategory  = $("#ratingCategory option:selected").data("code");
  // console.log(packet);
  // return;
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
