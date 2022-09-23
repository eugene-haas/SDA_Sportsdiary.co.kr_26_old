<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()

	iPlayerIDX = fInject(Request("iPlayerIDX"))
	iGameScoreIDX = fInject(Request("iGameScoreIDX"))
	iGroupGameGbName = fInject(Request("iGroupGameGbName"))

	iPlayerIDX = decode(iPlayerIDX,0)

  'iPlayerIDX = "1403"
  'iGameScoreIDX = "1588"
  'iGroupGameGbName = "sd040001"


  Dim iRGameLevelidx, iGameTitleIDX, iGroupGameGb, iGroupGameGbName, iGroupGameNum, iGameNum

  iType = "1"
  iSportsGb = "judo"

  LSQL = "EXEC Stat_TM_Record_Detail_Score_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','','','','',''"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        iRGameLevelidx = LRs("RGameLevelidx")
        iGameTitleIDX = LRs("GameTitleIDX")
        iGroupGameGb = LRs("GroupGameGb")
        iGroupGameGbName = LRs("GroupGameGbName")
        iGroupGameNum = LRs("GroupGameNum")
        iGameNum = LRs("GameNum")

      LRs.MoveNext
		Loop
  else

	End If

  LRs.close


  Dim iLTeamNm, iRTeamNm, iLPlayerName, iRPlayerName, iPlayerResultName, iMediaLink, iLRPlayerType

  iType = "2"
  iSportsGb = "judo"

  LSQL = "EXEC Stat_TM_Record_Detail_Score_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','" & iRGameLevelidx & "','" & iGameTitleIDX & "','" & iGroupGameGb & "','" & iGroupGameNum & "','" & iGameNum & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        iLTeamNm = LRs("LTeamNm")
        iRTeamNm = LRs("RTeamNm")
        iLPlayerName = LRs("LPlayerName")
        iRPlayerName = LRs("RPlayerName")
        iPlayerResultName = LRs("PlayerResultName")
        iMediaLink = LRs("MediaLink")
        iLRPlayerType = LRs("LRPlayerType")

      LRs.MoveNext
		Loop
  else

	End If

  LRs.close


  Dim LRsCnt5, iLPlayerName5, iRPlayerName5, iPlayerResultName5, iLRPlayerType5, iLJumsu5, iRJumsu5, iMediaLink5
  LRsCnt5 = 0

  iType = "51"
  iSportsGb = "judo"

  LSQL = "EXEC Stat_TM_Record_Detail_Score_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','" & iRGameLevelidx & "','" & iGameTitleIDX & "','" & iGroupGameGb & "','" & iGroupGameNum & "','" & iGameNum & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt5 = LRsCnt5 + 1

        iLPlayerName5 = iLPlayerName5&"^"&LRs("LPlayerName")&""
        iRPlayerName5 = iRPlayerName5&"^"&LRs("RPlayerName")&""
        iPlayerResultName5 = iPlayerResultName5&"^"&LRs("PlayerResultName")&""
        iLRPlayerType5 = iLRPlayerType5&"^"&LRs("LRPlayerType")&""
        iLJumsu5 = iLJumsu5&"^"&LRs("LJumsu")&""
        iRJumsu5 = iRJumsu5&"^"&LRs("RJumsu")&""
        iMediaLink5 = iMediaLink5&"^"&LRs("MediaLink")&""

      LRs.MoveNext
		Loop
  else

	End If

  LRs.close

  Dbclose()


%>

<% if LRsCnt5 = 0 then %>

<div class="modal-content">
  <!-- S: modal-header -->
  <div class="modal-header chk-score">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title" id="modal-title">SCORE</h4>
  </div>
  <!-- E: modal-header -->
  <div class="modal-body group-modal">
    <h2><span class="left-arrow">
      <img src="../../webtournament/www/images/tournerment/tourney/yellow-larr.png" alt></span><span id="DP_WinGroup"></span><span class="right-arrow"><img src="../../webtournament/www/images/tournerment/tourney/yellow-rarr.png" alt></span></h2>
    <!-- S: display-board -->
    <div class="display-board clearfix">
      <ul>
        <li class="win" id="DP_LSchoolName"></li>
        <li id="DP_LResult">0승0무0패(0)</li>
      </ul>
      <div class="v-s">
        VS
      </div>
      <ul class="away">
        <li id="DP_RSchoolName"></li>
        <li id="DP_RResult">0승0무0패(0)</li>
      </ul>
    </div>
    <!-- E: display-board -->
    <!-- S:record -->
    <div class="record record-box">
      <!-- S: guide-txt -->
      <div class="guide-txt">
        ※상세 기술의 경우 현장 기록관의 주관적인 판단에 의해 기록되므로 약간의 시각차가 있을 수 있습니다. <br>
        ※ 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
      </div>
      <!-- E: guide-txt -->
      <div class="home-team" id="DP_LeftGroup">
        <ul class="title clearfix">
          <li>선수명</li>
          <li>체급항목</li>
          <li>승패</li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
      </div>
      <div class="v-s">
        VS
      </div>
      <div class="away-team" id="DP_RightGroup">
        <ul class="title clearfix">
          <li>승패</li>
          <li>체급항목</li>
          <li>선수명</li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
        <ul class="clearfix">
          <li></li>
          <li></li>
          <li></li>
        </ul>
      </div>
    </div>
    <!-- E: record -->
    <!-- S: 영상보기 film-box -->
    <div class="film-box panel" style="display: none;">
      <!-- S: guide-txt -->
      <!-- <div class="guide-txt show-film-guide">
        ※ 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
      </div> -->
      <!-- E: guide-txt -->
      <iframe width="100%" height="260" src="" frameborder="0" allowfullscreen></iframe>
    </div>
    <!-- E: 영상보기 film-box -->
    <!-- S: modal footer -->
    <div class="modal-footer">
      <div class="btn-list flex">
        <button type="button" class="btn btn-orange btn-film" style="display: block;"><span class="ic-deco">
          <img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt="" /></span>영상보기</button>
        <a href="#" id="btn_log" role="button" class="btn btn-orange btn-record" style="display: none">기록보기</a>
        <a href="#" role="button" class="btn btn-close btn-ins btn-default" data-dismiss="modal">닫기</a>
      </div>
    </div>
    <!--E: modal-footer -->
  </div>
  <!-- E: modal-body -->
</div>
<!-- modal-content -->

<% else %>

<div class="modal-content">
  <!-- S: modal-header -->
  <div class="modal-header chk-score">
    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
    <h4 class="modal-title" id="modal-title">SCORE</h4>
  </div>
  <!-- E: modal-header -->
  <div class="modal-body group-modal">
    <h2><span class="left-arrow">
      <img src="../../webtournament/www/images/tournerment/tourney/yellow-larr.png" alt></span><span id="iWinTeamNm">송도고등학교</span><span id="iWinTeamPoint">(200점)</span><span class="right-arrow"><img src="../../webtournament/www/images/tournerment/tourney/yellow-rarr.png" alt></span></h2>
    <!-- S: display-board -->
    <div class="display-board clearfix">
      <ul>
        <li class="win" id="iLTeamNm">송도고등학교</li>
        <li id="iDP_LResult">0승0무0패(0)</li>
      </ul>
      <div class="v-s">
        VS
      </div>
      <ul class="away">
        <li id="iRTeamNm">우석고등학교</li>
        <li id="iDP_RResult">0승0무0패(0)</li>
      </ul>
    </div>
    <!-- E: display-board -->
    <!-- S:record -->
    <div class="record record-box">
      <!-- S: guide-txt -->
      <div class="guide-txt">
        ※상세 기술의 경우 현장 기록관의 주관적인 판단에 의해 기록되므로 약간의 시각차가 있을 수 있습니다. <br>
        ※ 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
      </div>
      <!-- E: guide-txt -->
      <div class="home-team" id="iLTeamGroup">
        <ul class="title clearfix">
          <li>선수명</li>
          <li>체급항목</li>
          <li>승패</li>
        </ul>
      </div>
      <div class="v-s">
        VS
      </div>
      <div class="away-team" id="iRTeamGroup">
        <ul class="title clearfix">
          <li>승패</li>
          <li>체급항목</li>
          <li>선수명</li>
        </ul>
      </div>
    </div>
    <!-- E: record -->
    <!-- S: 영상보기 film-box -->
    <div class="film-box panel" style="display: none;">
      <!-- S: guide-txt -->
      <!-- <div class="guide-txt show-film-guide">
        ※ 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
      </div> -->
      <!-- E: guide-txt -->
      <% if iMediaLink = "" then %>
      <p class="no-data">데이터가 없습니다.</p>
      <% else %>
      <iframe id="iframeMov" width="100%" height="260" src="<%=iMediaLink %>?rel=0" frameborder="0" allowfullscreen></iframe>
      <% end if %>
    </div>
    <!-- E: 영상보기 film-box -->
    <!-- S: modal footer -->
    <div class="modal-footer">
      <div class="btn-list flex">
        <button type="button" class="btn btn-orange btn-film" onclick="changeDet('OPEN','<%=iMediaLink %>');" style="display: block;"><span class="ic-deco">
          <img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt="" /></span>영상보기</button>
        <a href="#" id="btn_log" role="button" class="btn btn-orange btn-record" style="display: none" onclick="changeDet('CLOSE','');">기록보기</a>
        <a href="#" role="button" class="btn btn-close btn-ins btn-default" data-dismiss="modal" onclick="changeDet('CLOSE','');">닫기</a>
      </div>
    </div>
    <!--E: modal-footer -->
  </div>
  <!-- E: modal-body -->
</div>
<!-- modal-content -->


<% end if %>

<script type="text/javascript">

  var TCnt5 = Number("<%=LRsCnt5%>");

  if (TCnt5 > 0) {

    //팀 승패 타이틀
    var iLTeamNm = "<%=iLTeamNm%>";
    var iRTeamNm = "<%=iRTeamNm%>";
    var iPlayerResultName = "<%=iPlayerResultName%>";
    var iLRPlayerType = "<%=iLRPlayerType%>";

    if (iLRPlayerType == "LPlayer") {

      $('#iRTeamNm').removeClass('win');
      $('#iLTeamNm').addClass('win');

      $('#iWinTeamNm').text(iLTeamNm);

    }
    else {

      $('#iLTeamNm').removeClass('win');
      $('#iRTeamNm').addClass('win');

      $('#iWinTeamNm').text(iRTeamNm);

    }

    $('#iLTeamNm').text(iLTeamNm);
    $('#iRTeamNm').text(iRTeamNm);



    //팀 승패 세부 내역
    var iLPlayerName5 = "<%=iLPlayerName5%>";
    var iRPlayerName5 = "<%=iRPlayerName5%>";
    var iPlayerResultName5 = "<%=iPlayerResultName5%>";
    var iLRPlayerType5 = "<%=iLRPlayerType5%>";
    var iLJumsu5 = "<%=iLJumsu5%>";
    var iRJumsu5 = "<%=iRJumsu5%>";
    var iMediaLink5 = "<%=iMediaLink5%>";

    var iLPlayerName5arr = iLPlayerName5.split("^");
    var iRPlayerName5arr = iRPlayerName5.split("^");
    var iPlayerResultName5arr = iPlayerResultName5.split("^");
    var iLRPlayerType5arr = iLRPlayerType5.split("^");
    var iLJumsu5arr = iLJumsu5.split("^");
    var iRJumsu5arr = iRJumsu5.split("^");
    var iMediaLink5arr = iMediaLink5.split("^");

    //승무패 계산, 총점계산 , 현재 무승부 로직 없음
    var iLWinResult = 0;
    var iLDrawResult = 0;
    var iLLoseResult = 0;

    var iRWinResult = 0;
    var iRDrawResult = 0;
    var iRLoseResult = 0;

    var iTLJumsu = 0;
    var iTRJumsu = 0;

    var iLhtmlP = "";
    var iRhtmlP = "";

    for (var i = 1; i < TCnt5 + 1; i++) {

      if (iLRPlayerType5arr[i] == "RPlayer" && iPlayerResultName5arr[i].substring(0, 1) == "승") {

        iRWinResult = iRWinResult + 1;

      }
      else if (iLRPlayerType5arr[i] == "LPlayer" && iPlayerResultName5arr[i].substring(0, 1) == "승") {

        iLWinResult = iLWinResult + 1;

      }

      iTLJumsu = iTLJumsu + Number(iLJumsu5arr[i]);
      iTRJumsu = iTRJumsu + Number(iRJumsu5arr[i]);

    }

    iRLoseResult = TCnt5 - iRWinResult;
    iLLoseResult = TCnt5 - iLWinResult;

    iLhtmlP = iLWinResult + '승' + iLLoseResult + '패';
    //iLhtmlP = iLhtmlP + '<br>';
    iLhtmlP = iLhtmlP + '(' + iTLJumsu + ')';

    //alert(iLhtmlP);

    $('#iDP_LResult').html(iLhtmlP);

    iRhtmlP = iRWinResult + '승' + iRLoseResult + '패';
    //iRhtmlP = iRhtmlP + '<br>';
    iRhtmlP = iRhtmlP + '(' + iTRJumsu + ')';

    $('#iDP_RResult').html(iRhtmlP);


    if (iLRPlayerType == "LPlayer") {
      $('#iWinTeamPoint').html('(' + iTLJumsu + ')');
    }
    else {
      $('#iWinTeamPoint').html('(' + iTRJumsu + ')');
    }


    var iLhtml = "";
    var iRhtml = "";

    for (var i = 1; i < TCnt5 + 1; i++) {

      iLhtml = '<ul class="clearfix">';
      iLhtml = iLhtml + '<li>' + iLPlayerName5arr[i] + '</li>';
      iLhtml = iLhtml + '<li></li>';

      if (iLRPlayerType5arr[i] == "LPlayer") {
        iLhtml = iLhtml + '<li>' + iPlayerResultName5arr[i] + '</li>';
      }
      else {
        iLhtml = iLhtml + '<li></li>';
      }

      iLhtml = iLhtml + '</ul>';

      $('#iLTeamGroup').append(iLhtml);


      iRhtml = '<ul class="clearfix">';

      if (iLRPlayerType5arr[i] == "RPlayer") {
        iRhtml = iRhtml + '<li>' + iPlayerResultName5arr[i] + '</li>';
      }
      else {
        iRhtml = iRhtml + '<li></li>';
      }

      iRhtml = iRhtml + '<li></li>';
      iRhtml = iRhtml + '<li>' + iRPlayerName5arr[i] + '</li>';

      iRhtml = iRhtml + '</ul>';

      $('#iRTeamGroup').append(iRhtml);

    }
  }

  	function changeDet(act, url){
		if(act=="OPEN"){
			if(!$('#iframeMov').attr('src')) $('#iframeMov').attr('src', url);
		}
		else{
			$('#iframeMov').attr('src', '');
		}
	}

</script>
