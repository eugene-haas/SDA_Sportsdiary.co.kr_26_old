<script type="text/javascript">

  //alert('test');

  function iMovieLink(link1, link2, link3) {

    alert(link1 + "," + link2 + "," + link3);


    if (link2 == "sd040001") {

        //alert('개인');

        var strAjaxUrl = "../Ajax/match-film-DetailScore-Sch.asp";

        //alert(strAjaxUrl);

        $.ajax({
            url: strAjaxUrl,
            type: 'POST',
            dataType: 'html',
            data: {
                iPlayerIDX: link3,
                iGameScoreIDX: link1,
                iGroupGameGbName: link2
            },
            success: function (retDATA) {
                if (retDATA) {
                    //alert(retDATA);
                    $('#detailScore').html(retDATA);
                    $('.film-modal').filmTab('.film-modal');
                    $('.groups-res').filmTab('.groups-res');
                } else {
                    $('#detailScore').html("");
                }
            }, error: function (xhr, status, error) {
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
        });
    }
    else {

        //alert('단체');

        var strAjaxUrl = "../Ajax/match-film-DetailScore-Sch-Team.asp";

        //alert(strAjaxUrl);

        $.ajax({
            url: strAjaxUrl,
            type: 'POST',
            dataType: 'html',
            data: {
                iPlayerIDX: link3,
                iGameScoreIDX: link1,
                iGroupGameGbName: link2
            },
            success: function (retDATA) {
                if (retDATA) {
                    //alert(retDATA);
                    $('#detailScore_Team').html(retDATA);
                    $('.film-modal').filmTab('.film-modal');
                    $('#groupround-res').filmTab('#groupround-res');
                } else {
                    $('#detailScore_Team').html("");
                }
            }, error: function (xhr, status, error) {
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
        });

    }

  }

</script>

<!-- S: film-modal -->
<div class="modal fade film-modal" id="show-score" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false">
  <div class="modal-backdrop fade in"></div>
  <div id="detailScore"></div>
</div>
<!-- E: film-modal -->
<!-- S: Winner  result Modal -->
<div class="modal fade round-res" id="groupround-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true">
  <div class="modal-dialog">
    <div id="detailScore_Team"> </div>
  </div>
</div>
<!-- E: Winner-1 result Modal -->