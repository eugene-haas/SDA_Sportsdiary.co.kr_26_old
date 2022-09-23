<!--#include file="../Library/ajax_config.asp"-->
<%

  iPlayerIDX = fInject(Request("iPlayerIDX"))
  iGameScoreIDX = fInject(Request("iGameScoreIDX"))
	iGroupGameGbName = fInject(Request("iGroupGameGbName"))

  iPlayerIDX = decode(iPlayerIDX,0)

  'iPlayerIDX = "1403"
  'iGameScoreIDX = "1588"
  'iGroupGameGbName = "sd040001"

 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType")

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가


  Dim iRGameLevelidx, iGameTitleIDX, iGroupGameGb, iGroupGameGbName, iGroupGameNum, iGameNum

  iType = "1"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Detail_Score_Game_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','','','','',''"
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
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Detail_Score_Game_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','" & iRGameLevelidx & "','" & iGameTitleIDX & "','" & iGroupGameGb & "','" & iGroupGameNum & "','" & iGameNum & "'"
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


  Dim iLResultName, iLJumsu, LRsCnt1, iLRPlayerType2
  LRsCnt1 = 0

  iType = "21"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Detail_Score_Game_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','" & iRGameLevelidx & "','" & iGameTitleIDX & "','" & iGroupGameGb & "','" & iGroupGameNum & "','" & iGameNum & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1

        'iWResultName = LRs("ResultName")
        'iWJumsu = LRs("Jumsu")

        iLResultName = iLResultName&"^"&LRs("ResultName")&""
        iLJumsu = iLJumsu&"^"&LRs("Jumsu")&""
        iLRPlayerType2 = iLRPlayerType2&"^"&LRs("LRPlayerType")&""

      LRs.MoveNext
		Loop
  else

	End If

  LRs.close


  Dim iRResultName, iRJumsu, LRsCnt2, iLRPlayerType3
  LRsCnt2 = 0

  iType = "31"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Detail_Score_Game_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','" & iRGameLevelidx & "','" & iGameTitleIDX & "','" & iGroupGameGb & "','" & iGroupGameNum & "','" & iGameNum & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1

        iRResultName = iRResultName&"^"&LRs("ResultName")&""
        iRJumsu = iRJumsu&"^"&LRs("Jumsu")&""
        iLRPlayerType3 = iLRPlayerType3&"^"&LRs("LRPlayerType")&""

      LRs.MoveNext
		Loop
  else

	End If

  LRs.close


  Dim iResultName, iSpecialtyDtlName, iCheckTime, iUserName, iLRPlayerType1, LRsCnt3
  LRsCnt3 = 0

  iType = "42"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Detail_Score_Game_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','" & iRGameLevelidx & "','" & iGameTitleIDX & "','" & iGroupGameGb & "','" & iGroupGameNum & "','" & iGameNum & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt3 = LRsCnt3 + 1

        iResultName = iResultName&"^"&LRs("ResultName")&""
        iSpecialtyDtlName = iSpecialtyDtlName&"^"&LRs("SpecialtyDtlName")&""
        iCheckTime = iCheckTime&"^"&LRs("CheckTime")&""
        iUserName = iUserName&"^"&LRs("UserName")&""
        iLRPlayerType1 = iLRPlayerType1&"^"&LRs("LRPlayerType")&""
        iOverTime = iOverTime&"^"&LRs("OverTime")&""

      LRs.MoveNext
		Loop
  else

	End If

  LRs.close

  Dbclose()


%>

<% if iPlayerResultName = "" then %>

<!-- S: modal-dialog -->
<div class="modal-dialog">
  <!-- S: modal-content -->
  <div class="modal-content">
    <div class="modal-header clearfix">
      <h3 class="center">상세 스코어</h3>
      <a href="#" data-dismiss="modal">&times;</a>
    </div>
    <!-- E: modal-content -->
    <!-- S: modal-body -->
    <div class="modal-body">
      <!-- S: pracice-score -->
      <div id="modal_score" class="pracice-score" style="width: 100%">
        <h4><span>No Data</span></h4>
        <!-- S: pop-point-display -->
        <div class="pop-point-display">
          <!-- S: display-board -->
          <div class="display-board clearfix">
            <!-- S: point-display -->
            <div class="point-display clearfix">
              <ul class="point-title flex">
                <li>선수</li>
                <li>한판</li>
                <li>절반</li>
                <!-- <li>유효</li> -->
                <li>지도</li>
                <li>반칙/실격/<br>
                  부전/기권 승</li>
              </ul>
              <ul class="player-1-point player-point flex">
                <li>
                  <a onclick="#"><span class="disp-none"></span><span class="player-name" id="0DP_Edit_LPlayer"></span>
                    <p class="player-school" id=""></p>
                  </a>
                  <p class="vs">vs</p>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb">
                    <span class="score" id="0LJumsuGb1">
                      0
                    </span>
                  </a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb">
                    <span class="score" id="0LJumsuGb2">
                      0
                    </span>
                  </a>
                </li>
                <!-- <li class="tgClass">
                        <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3">0</span></a>
                      </li> -->
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb">
                    <span class="score txt-orange" id="0LJumsuGb4">
                      0
                    </span>
                  </a>
                </li>
                <li>
                  <select class="select-win select-box" id="0DP_R_GameResultL" disabled>
                    <option value=""></option>
                    <!--<option value="">선택</option>
                    <option value="">반칙</option>
                    <option value="">실격</option>
                    <option value="">부전</option>
                    <option value="">기권</option>-->
                  </select>
                </li>
              </ul>
              <ul class="player-2-point player-point flex">
                <li>
                  <a onclick="#"><span class="disp-none"></span><span class="player-name" id="0DP_Edit_RPlayer"></span>
                    <p class="player-school" id=""></p>
                  </a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score" id="0RJumsuGb1">0</span></a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score" id="0RJumsuGb2">0</span></a>
                </li>
                <!-- <li class="tgClass">
                        <a class="" onclick="#" name="a_jumsugb"><span class="score" id="0RJumsuGb3">0</span></a>
                      </li> -->
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="0RJumsuGb4">0</span></a>
                </li>
                <li>
                  <select class="select-win select-box" id="0DP_R_GameResultR" disabled>
                    <option value=""></option>
                    <!--<option value="">선택</option>
                    <option value="">반칙</option>
                    <option value="">실격</option>
                    <option value="">부전</option>
                    <option value="">기권</option>-->
                  </select>
                </li>
              </ul>
              <!-- E: point-display -->
            </div>
            <!-- E: point-display -->
          </div>
          <!-- E: display-board -->
        </div>
        <!-- E: pop-point-display -->
      </div>
      <!-- E: pracice-score -->
    </div>
    <!-- E: -->
    <!-- S: container -->
    <div class="container">
      <!-- S: 기록보기 record-box -->
      <div id="0modal_container" class="record-box panel" style="display: block;">
        <!-- S: guide-txt -->
        <div class="guide-txt">
          ※상세 기술의 경우 현장 기록관의 주관적인 판단에 의해 기록되므로 약간의 시각차가 있을 수 있습니다. <br>
          ※ 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
        </div>
        <!-- E: guide-txt -->
        <h3>득실기록</h3>
        <!--<ul class="plactice-txt">
          <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
          <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
          <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
          <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
          <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
          <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
          <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
          <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
          <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
        </ul>-->
      </div>
      <!-- E: 기록보기 record-box -->
      <!-- S: 영상보기 film-box -->
      <div class="film-box panel" style="display: none;">
        <!-- S: guide-txt -->
        <!-- <div class="guide-txt show-film-guide">
          ※ 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
        </div> -->
        <!-- E: guide-txt -->
        <iframe width="100%" height="160" src="" frameborder="0" allowfullscreen=""></iframe>
      </div>
      <!-- E: 영상보기 film-box -->
    </div>
    <!-- E: container -->
  </div>
  <!-- E: modal-body -->
  <!-- S: modal-footer -->
  <div class="modal-footer">
    <!-- S: btn-list -->
    <div class="btn-list flex">
      <button type="button" class="btn btn-orange btn-film off" style="display: block;">영상미등록</button>
      <button type="button" class="btn btn-orange btn-record" style="display: none;">기록보기</button>
      <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
    </div>
    <!-- E: btn-list -->
  </div>
  <!-- E: modal-footer -->
</div>
    <!-- E: modal-dialog -->

<% else %>
<!-- S: modal-dialog -->
<div class="modal-dialog">
  <!-- S: modal-content -->
  <div class="modal-content">
    <div class="modal-header clearfix">
      <h3 class="center">상세 스코어</h3>
      <a href="#" data-dismiss="modal">&times;</a>
    </div>
    <!-- E: modal-content -->
    <!-- S: modal-body -->
    <div class="modal-body">
      <!-- S: pracice-score -->
      <div id="modal_score" class="pracice-score" style="width: 100%">
        <h4><span><%=iPlayerResultName %></span></h4>
        <!-- S: pop-point-display -->
        <div class="pop-point-display">
          <!-- S: display-board -->
          <div class="display-board clearfix">
            <!-- S: point-display -->
            <div class="point-display clearfix">
              <ul class="point-title flex">
                <li>선수</li>
                <li>한판</li>
                <li>절반</li>
                <!-- <li>유효</li> -->
                <li>지도</li>
                <li id="DP_GameResultli">반칙/실격/<br>
                  부전/기권 승</li>
              </ul>
              <ul class="player-1-point player-point flex">
                <li>
                  <a onclick="#"><span class="disp-none" id="iLWImg"></span><span class="player-name" id="DP_Edit_LPlayer"><%=iLPlayerName %></span>
                    <p class="player-school" id=""><%=iLTeamNm %></p>
                  </a>
                  <p class="vs">vs</p>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb">
                    <span class="score" id="LJumsuGb1">
                      0
                    </span>
                  </a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb">
                    <span class="score" id="LJumsuGb2">
                      0
                    </span>
                  </a>
                </li>
                <!-- <li class="tgClass">
                        <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3">0</span></a>
                      </li> -->
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb">
                    <span class="score txt-orange" id="LJumsuGb4">
                      0
                    </span>

                  </a>
                </li>
                <li id="DP_L_GameResultli">
                  <select class="select-win select-box" id="DP_L_GameResult" disabled>
                    <!--<option value="">선택</option>
                    <option value="">반칙</option>
                    <option value="">실격</option>
                    <option value="">부전</option>
                    <option value="">기권</option>-->
                  </select>
                </li>
              </ul>
              <ul class="player-2-point player-point flex">
                <li>
                  <a onclick="#"><span class="disp-none" id="iRWImg"></span><span class="player-name" id="DP_Edit_RPlayer"><%=iRPlayerName %></span>
                    <p class="player-school" id=""><%=iRTeamNm %></p>
                  </a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb1">0</span></a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb2">0</span></a>
                </li>
                <!-- <li class="tgClass">
                        <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
                      </li> -->
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb4">0</span></a>
                </li>
                <li id="DP_R_GameResultli">
                  <select class="select-win select-box" id="DP_R_GameResult" disabled>
                    <!--<option value="">선택</option>
                    <option value="">반칙</option>
                    <option value="">실격</option>
                    <option value="">부전</option>
                    <option value="">기권</option>-->
                  </select>
                </li>
              </ul>
              <!-- E: point-display -->
            </div>
            <!-- E: point-display -->
          </div>
          <!-- E: display-board -->
        </div>
        <!-- E: pop-point-display -->
      </div>
      <!-- E: pracice-score -->
    </div>
    <!-- E: -->
    <!-- S: container -->
    <div class="container">
      <!-- S: 기록보기 record-box -->
      <div id="modal_container" class="record-box panel" style="display: block;">
        <!-- S: guide-txt -->
        <div class="guide-txt">
          ※상세 기술의 경우 현장 기록관의 주관적인 판단에 의해 기록되므로 약간의 시각차가 있을 수 있습니다. <br>
          ※ 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
        </div>
        <!-- E: guide-txt -->
        <h3>득실기록</h3>
        <ul class="plactice-txt" id="praticetxt">
          <!--<li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
          <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
          <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
          <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
          <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
          <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
          <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
          <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
          <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>-->
        </ul>
      </div>
      <!-- E: 기록보기 record-box -->
      <!-- S: 영상보기 film-box -->
      <div class="film-box panel" style="display: none;">
        <!-- S: guide-txt -->
        <!-- <div class="guide-txt show-film-guide">
          ※ 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
        </div> -->
        <!-- E: guide-txt -->
        <% if iMediaLink = "" then %>
        <p>데이터가 없습니다.</p>
        <% else %>
        <iframe id="iframeMov" width="100%" height="160" src="<%=iMediaLink %>" frameborder="0" allowfullscreen=""></iframe>
        <% end if %>
      </div>
      <!-- E: 영상보기 film-box -->
    </div>
    <!-- E: container -->
  </div>
  <!-- E: modal-body -->
  <!-- S: modal-footer -->
  <div class="modal-footer">
    <!-- S: btn-list -->
    <div class="btn-list flex">
      <button type="button" class="btn btn-orange btn-film <%IF iMediaLink="" Then response.Write "off" End IF%>" onclick="changeDet('OPEN','<%=iMediaLink %>');" style="display: block;">
        <%
	  	IF iMediaLink="" Then
	  		response.Write "영상미등록"
		Else
			response.write "<span class=""ic-deco""> <img src=""http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png"" alt=""""></span>"
			response.Write "영상보기"
		End IF
		%></button>
      <button type="button" class="btn btn-orange btn-record" style="display: none;" onclick="changeDet('CLOSE','');">기록보기</button>
      <button type="button" class="btn btn-default" data-dismiss="modal" onclick="changeDet('CLOSE','');">닫기</button>
    </div>
    <!-- E: btn-list -->
  </div>
  <!-- E: modal-footer -->
</div>
    <!-- E: modal-dialog -->
<% end if %>

<script type="text/javascript">

  // 좌우측선수 점수 넣기 ( 여기가 좌측이면 아래가 우측, 여기가 우측이면 아래가 좌측 )
  var TCnt1 = Number("<%=LRsCnt1%>");
  //alert(TCnt1);

  if (TCnt1 > 0) {

    var iLResultName = "<%=iLResultName%>";
    var iLJumsu = "<%=iLJumsu%>";
    var iLRPlayerType2 = "<%=iLRPlayerType2%>";

    var iLResultNamearr = iLResultName.split("^");
    var iLJumsuarr = iLJumsu.split("^");
    var iLRPlayerType2arr = iLRPlayerType2.split("^");

    for (var i = 1; i < TCnt1 + 1; i++) {

      if (iLResultNamearr[i] == "한판") {
        if (iLRPlayerType2arr[i] == "RPlayer") {
          $('#RJumsuGb1').text(iLJumsuarr[i]);
        }
        else {
          $('#LJumsuGb1').text(iLJumsuarr[i]);
        }
      }
      else if (iLResultNamearr[i] == "절반") {
        if (iLRPlayerType2arr[i] == "RPlayer") {
          $('#RJumsuGb2').text(iLJumsuarr[i]);
        }
        else {
          $('#LJumsuGb2').text(iLJumsuarr[i]);
        }
      }
      else if (iLResultNamearr[i] == "지도") {
        if (iLRPlayerType2arr[i] == "RPlayer") {
          $('#RJumsuGb4').text(iLJumsuarr[i]);
        }
        else {
          $('#LJumsuGb4').text(iLJumsuarr[i]);
        }
      }

    }

  }

  // 우측선수 점수 넣기
  var TCnt2 = Number("<%=LRsCnt2%>");
  //alert(TCnt1);

  if (TCnt2 > 0) {

    var iRResultName = "<%=iRResultName%>";
    var iRJumsu = "<%=iRJumsu%>";
    var iLRPlayerType3 = "<%=iLRPlayerType3%>";

    var iRResultNamearr = iRResultName.split("^");
    var iRJumsuarr = iRJumsu.split("^");
    var iLRPlayerType3arr = iLRPlayerType3.split("^");

    for (var i = 1; i < TCnt2 + 1; i++) {

      if (iRResultNamearr[i] == "한판") {
        if (iLRPlayerType3arr[i] == "RPlayer") {
          $('#RJumsuGb1').text(iRJumsuarr[i]);
        }
        else {
          $('#LJumsuGb1').text(iRJumsuarr[i]);
        }
      }
      else if (iRResultNamearr[i] == "절반") {
        if (iLRPlayerType3arr[i] == "RPlayer") {
          $('#RJumsuGb2').text(iRJumsuarr[i]);
        }
        else {
          $('#LJumsuGb2').text(iRJumsuarr[i]);
        }
      }
      else if (iRResultNamearr[i] == "지도") {
        if (iLRPlayerType3arr[i] == "RPlayer") {
          $('#RJumsuGb4').text(iRJumsuarr[i]);
        }
        else {
          $('#LJumsuGb4').text(iRJumsuarr[i]);
        }
      }

    }

  }


  // 반칙 등 넣기
  var iPlayerResultName = "<%=iPlayerResultName%>";

  // 승 이미지
  if (iLRPlayerType == "LPlayer") {
    $('#iLWImg').removeClass('disp-none');
    $('#iLWImg').addClass('disp-win');
  }
  else {
    $('#iRWImg').removeClass('disp-none');
    $('#iRWImg').addClass('disp-win');
  }

  if (iPlayerResultName != "") {

    var iPlayerResultName = "<%=iPlayerResultName%>";
    var iLRPlayerType = "<%=iLRPlayerType%>";

    //iLRPlayerType = "A";

    //alert(iLRPlayerType);

    if (iPlayerResultName == "승(반칙)") {
      if (iLRPlayerType == "LPlayer") {
        $("#DP_L_GameResult").append("<option value=''>반칙승</option>");
      }
      else {
        $("#DP_R_GameResult").append("<option value=''>반칙승</option>");
      }
    }
    else if (iPlayerResultName == "승(실격)") {
      if (iLRPlayerType == "LPlayer") {
        $("#DP_L_GameResult").append("<option value=''>실격승</option>");
      }
      else {
        $("#DP_R_GameResult").append("<option value=''>실격승</option>");
      }
    }
    else if (iPlayerResultName == "승(부전)") {
      if (iLRPlayerType == "LPlayer") {
        $("#DP_L_GameResult").append("<option value=''>부전승</option>");
      }
      else {
        $("#DP_R_GameResult").append("<option value=''>부전승</option>");
      }
    }
    else if (iPlayerResultName == "승(기권)") {
      if (iLRPlayerType == "LPlayer") {
        $("#DP_L_GameResult").append("<option value=''>기권승</option>");
      }
      else {
        $("#DP_R_GameResult").append("<option value=''>기권승</option>");
      }
    }
    //else if (iPlayerResultName == "승(절반)") {
    //  if (iLRPlayerType == "LPlayer") {
    //    $("#DP_L_GameResult").append("<option value=''>절반</option>");
    //  }
    //  else {
    //    $("#DP_R_GameResult").append("<option value=''>절반</option>");
    //  }
    //}
    else {
      //$('#DP_GameResultli').remove();
      //$('#DP_L_GameResultli').remove();
      //$('#DP_R_GameResultli').remove();
    }


    var TCnt3 = Number("<%=LRsCnt3%>");
    //alert(TCnt3);

    if (TCnt3 > 0) {

      var iResultName = "<%=iResultName%>";
      var iSpecialtyDtlName = "<%=iSpecialtyDtlName%>";
      var iCheckTime = "<%=iCheckTime%>";
      var iUserName = "<%=iUserName%>";
      var iLRPlayerType1 = "<%=iLRPlayerType1%>";
      var iOverTime = "<%=iOverTime%>";

      var iResultNamearr = iResultName.split("^");
      var iSpecialtyDtlNamearr = iSpecialtyDtlName.split("^");
      var iCheckTimearr = iCheckTime.split("^");
      var iUserNamearr = iUserName.split("^");
      var iLRPlayerType1arr = iLRPlayerType1.split("^");
      var iOverTimearr = iOverTime.split("^");

      var ihtml = "";

      for (var i = 1; i < TCnt3 + 1; i++) {
        if (iLRPlayerType1arr[i] == "LPlayer") {
          ihtml = "<li class='pratice-txt-white'>";
        }
        else {
          ihtml = "<li class='pratice-txt-blue'>";
        }

        if (iOverTimearr[i] == "1") {
          ihtml = ihtml + "(연)";
        }

        ihtml = ihtml + "[" + iCheckTimearr[i] + "]" + iUserNamearr[i] + ": " + iResultNamearr[i] + "" + iSpecialtyDtlNamearr[i] + "</li>";
        $('#praticetxt').append(ihtml);
      }

      //for (var i = 1; i < TCnt1 + 1; i++) {
      //
      //  if (iLResultNamearr[i] == "한판") {
      //    $('#LJumsuGb1').text(iLJumsuarr[i]);
      //  }
      //  else if (iLResultNamearr[i] == "절반") {
      //    $('#LJumsuGb2').text(iLJumsuarr[i]);
      //  }
      //  else if (iLResultNamearr[i] == "지도") {
      //    $('#LJumsuGb4').text(iLJumsuarr[i]);
      //  }
      //
      //}

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
