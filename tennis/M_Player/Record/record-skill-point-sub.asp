<script type="text/javascript">

  function mySkillChart(ia, ib, ic, id) {

    //alert(ia + ', ' + ib + ', ' + ic + ', ' + id);

    $('#iName').text(ib);
    $('#iTeam').text('(' + ic + ')');

    if (id != "") {
      $('#iPhoto').html('<img src="../' + id.substring(3, id.length) + '" alt>');
    }
    else {
      $('#iPhoto').html('<img src="http://img.sportsdiary.co.kr/sdapp/gnb/profile@3x.png" alt="" />');
    }

    myPointChart_Main(ia);

  }

  function myPointChart_Main(ia) {



    var strJsonUrl = "../Json/record-skill-point.asp?SDate=" + sub_iSDate + "&EDate=" + sub_iEDate + "&Fnd_KeyWord=" + ia + "&Level=" + sub_ilevelname;

    //alert(strJsonUrl);

    FusionCharts.ready(function () {
      var demographicsChart = new FusionCharts({
        type: 'msbar3d',
        renderAt: 'chart',
        width: '100%',
        height: '380',
        dataFormat: 'jsonurl',
        dataSource: strJsonUrl
      }).render();
    });

  }

</script>

<!-- S: modal-record-rank -->
<div class="modal fade confirm-modal modal-record-rank" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">기술득점</h4>
            </div>
            <div class="modal-body">
                <!-- S: player-profile -->
                <div class="player-profile">
                    <div class="profile-img" id="iPhoto">
                        <img src="http://img.sportsdiary.co.kr/sdapp/gnb/profile@3x.png" alt="" />
                    </div>
                    <h3><span id="iName">최보라</span> <span id="iTeam">(철원고등학교)</span></h3>
                </div>
                <!-- E: player-profile -->
                <!--// chart가 들어갑니다. msbar3d. 20개 기술에 대한 득점, 실점 -->
                <div id="chart"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-gray" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>
<!-- E: modal-record-rank -->
