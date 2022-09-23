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


  Dim iLResultName, iLJumsu, LRsCnt1, iLRPlayerType2
  LRsCnt1 = 0

  iType = "21"
  iSportsGb = "judo"

  LSQL = "EXEC Stat_TM_Record_Detail_Score_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','" & iRGameLevelidx & "','" & iGameTitleIDX & "','" & iGroupGameGb & "','" & iGroupGameNum & "','" & iGameNum & "'"
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
  iSportsGb = "judo"

  LSQL = "EXEC Stat_TM_Record_Detail_Score_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','" & iRGameLevelidx & "','" & iGameTitleIDX & "','" & iGroupGameGb & "','" & iGroupGameNum & "','" & iGameNum & "'"
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
  iSportsGb = "judo"

  LSQL = "EXEC Stat_TM_Record_Detail_Score_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & iGameScoreIDX & "','" & iRGameLevelidx & "','" & iGameTitleIDX & "','" & iGroupGameGb & "','" & iGroupGameNum & "','" & iGameNum & "'"
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

<div class="modal-dialog">
  <div class="modal-content">
    <div class="modal-header clearfix">
      <h3 class="center">SCORE</h3>
      <a href="#" data-dismiss="modal" class="close">
        <!-- <img src="../images/public/close-x@3x.png" alt="닫기"> -->
        <span>&times;</span></a>
    </div>
    <div class="modal-body">
      <h4><span>한판승</span></h4>
      <div class="pracice-score" style="width: 100%">
        <!-- S: pop-point-display -->
        <div class="pop-point-display">
          <!-- S: display-board -->
          <div class="display-board clearfix">
            <!-- S: point-display -->
            <div class="point-display clearfix">
              <ul class="point-title clearfix">
                <li>선수</li>
                <li>한판</li>
                <li>절반</li>
                <!-- <li>유효</li> -->
                <li>지도</li>
                <li>반칙/실격/<br>
                  부전/기권 승</li>
                <li>양선수</li>
              </ul>
              <ul class="player-1-point player-point clearfix">
                <li>
                  <a onclick="#"><span class="disp-win"></span><span class="player-name"></span>
                    <p class="player-school" id="">충남체육고</p>
                  </a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score">0</span></a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score">0</span></a>
                </li>
                <!-- <li class="tgClass">
                <a class="" onclick="#" name="a_jumsugb"><span class="score">0</span></a>
              </li> -->
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange">0</span></a>
                </li>
                <li>
                  <!-- <select class="select-win select-box" id="DP_R_GameResult">
                  <option value="">선택</option>
                  <option value="">반칙</option>
                  <option value="">실격</option>
                  <option value="">부전</option>
                  <option value="">기권</option>
                </select> -->
                  <a class="" onclick="#" name="a_jumsugb"><span class="result"></span></a>
                </li>
                <!-- <li class="tgClass">
                <a class="" onclick="#" name="a_jumsugb"><span class="both">0</span></a>
              </li> -->
              </ul>
              <p class="vs">vs</p>
              <ul class="player-2-point player-point clearfix">
                <li>
                  <a onclick="#"><span class="disp-none"></span><span class="player-name"></span>
                    <p class="player-school" id=""></p>
                  </a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score">0</span></a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score">0</span></a>
                </li>
                <!-- <li class="tgClass">
                <a class="" onclick="#" name="a_jumsugb"><span class="score">0</span></a>
              </li> -->
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange">0</span></a>
                </li>
                <li>
                  <!-- <select class="select-win select-box" id="DP_R_GameResult">
                  <option value="">선택</option>
                  <option value="">반칙</option>
                  <option value="">실격</option>
                  <option value="">부전</option>
                  <option value="">기권</option>
                </select> -->
                  <a class="" onclick="#" name="a_jumsugb"><span class="result"></span></a>
                </li>
                <!-- <li class="tgClass">
                <a class="" onclick="#" name="a_jumsugb"><span class="both">0</span></a>
              </li> -->
              </ul>
              <!-- E: point-display -->
              <div class="player-match-option player-point">
                <label for="player-match-option-01" class="tgClass default" id="LRResult_Lose">
                  <input type="checkbox" id="player-match-option-01"><span></span></label>
                <label for="player-match-option-02" class="tgClass draw" id="LRResult_Draw">
                  <input type="checkbox" id="player-match-option-02"><span id="DP_DualResult_Text"></span></label>
              </div>
            </div>
            <!-- E: point-display -->
          </div>
          <!-- E: display-board -->
        </div>
        <!-- E: pop-point-display -->
      </div>
    </div>
    <div class="container">
      <!-- S: 기록보기 record-box -->
      <div class="record-box panel" style="display: block;">
        <!-- S: guide-txt -->
        <div class="guide-txt">
          ※상세 기술의 경우 현장 기록관의 주관적인 판단에 의해 기록되므로 약간의 시각차가 있을 수 있습니다. <br>
          ※ 당일 촬영장비 혹은 체육관 환경에 따라 서비스 제공이 불가할 수 있습니다.
        </div>
        <!-- E: guide-txt -->
        <h3>득실기록</h3>
        <ul class="plactice-txt">
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
        <iframe width="100%" height="260" src="" frameborder="0" allowfullscreen></iframe>
      </div>
      <!-- E: 영상보기 film-box -->
    </div>

    <div class="modal-footer">
      <div class="btn-list flex">
        <button type="button" class="btn btn-orange btn-film" style="display: block;"><span class="ic-deco">
          <img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt=""></span>영상보기</button>
        <button type="button" class="btn btn-orange btn-record" style="display: none;">기록보기</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<% else %>

<div class="modal-dialog">
  <div class="modal-content">
    <div class="modal-header clearfix">
      <h3 class="center">SCORE</h3>
      <a href="#" data-dismiss="modal" class="close">
        <!-- <img src="../images/public/close-x@3x.png" alt="닫기"> -->
        <span>&times;</span></a>
    </div>
    <div class="modal-body">
      <h4><span><%=iPlayerResultName %></span></h4>
      <div class="pracice-score" style="width: 100%">
        <!-- S: pop-point-display -->
        <div class="pop-point-display">
          <!-- S: display-board -->
          <div class="display-board clearfix">
            <!-- S: point-display -->
            <div class="point-display clearfix">
              <ul class="point-title clearfix">
                <li>선수</li>
                <li>한판</li>
                <li>절반</li>
                <!-- <li>유효</li> -->
                <li>지도</li>
                <li>반칙/실격/<br>
                  부전/기권 승</li>
                <!--<li>양선수</li>-->
                <li></li>
              </ul>
              <ul class="player-1-point player-point clearfix">
                <li>
                  <a onclick="#"><span class="disp-none" id="iLWImg"></span><span class="player-name" id="DP_Edit_LPlayer"><%=iLPlayerName %></span>
                    <p class="player-school" id=""><%=iLTeamNm %></p>
                  </a>
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
                <a class="" onclick="#" name="a_jumsugb"><span class="score">0</span></a>
              </li> -->
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb">
                    <span class="score txt-orange" id="LJumsuGb4">
                      0
                    </span>
                  </a>
                </li>
                <li>
                  <!-- <select class="select-win select-box" id="DP_R_GameResult">
                  <option value="">선택</option>
                  <option value="">반칙</option>
                  <option value="">실격</option>
                  <option value="">부전</option>
                  <option value="">기권</option>
                </select> -->
                  <a class="" onclick="#" name="a_jumsugb"><span class="result" id="DP_L_GameResult"></span></a>
                </li>
                <!-- <li class="tgClass">
                <a class="" onclick="#" name="a_jumsugb"><span class="both">0</span></a>
              </li> -->
              </ul>
              <p class="vs">vs</p>
              <ul class="player-2-point player-point clearfix">
                <li>
                  <a onclick="#"><span class="disp-none" id="iRWImg"></span><span class="player-name" id="DP_Edit_RPlayer"><%=iRPlayerName %></span>
                    <p class="player-school" id=""><%=iRTeamNm %></p>
                  </a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb">
                    <span class="score" id="RJumsuGb1">0</span>
                  </a>
                </li>
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb">
                    <span class="score" id="RJumsuGb2">0</span>
                  </a>
                </li>
                <!-- <li class="tgClass">
                <a class="" onclick="#" name="a_jumsugb"><span class="score">0</span></a>
              </li> -->
                <li class="tgClass">
                  <a class="" onclick="#" name="a_jumsugb">
                    <span class="score txt-orange" id="RJumsuGb4">0</span>
                  </a>
                </li>
                <li>
                  <!-- <select class="select-win select-box" id="DP_R_GameResult">
                  <option value="">선택</option>
                  <option value="">반칙</option>
                  <option value="">실격</option>
                  <option value="">부전</option>
                  <option value="">기권</option>
                </select> -->
                  <a class="" onclick="#" name="a_jumsugb"><span class="result" id="DP_R_GameResult"></span></a>
                </li>
                <!-- <li class="tgClass">
                <a class="" onclick="#" name="a_jumsugb"><span class="both">0</span></a>
              </li> -->
              </ul>
              <!-- E: point-display -->
              <!--<div class="player-match-option player-point">
                <label for="player-match-option-01" class="tgClass default" id="LRResult_Lose">
                  <input type="checkbox" id="player-match-option-01"><span></span></label>
                <label for="player-match-option-02" class="tgClass draw" id="LRResult_Draw">
                  <input type="checkbox" id="player-match-option-02"><span id="DP_DualResult_Text"></span></label>
              </div>-->
            </div>
            <!-- E: point-display -->
          </div>
          <!-- E: display-board -->
        </div>
        <!-- E: pop-point-display -->
      </div>
    </div>
    <div class="container">
      <!-- S: 기록보기 record-box -->
      <div class="record-box panel" id="modal_container" style="display: block;">
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
        <p class="no-data">데이터가 없습니다.</p>
        <% else %>
        <iframe id="iframeMov" width="100%" height="260" src="<%=iMediaLink %>?rel=0" frameborder="0" allowfullscreen></iframe>
        <% end if %>
      </div>
      <!-- E: 영상보기 film-box -->
    </div>

    <div class="modal-footer">
      <div class="btn-list flex">
        <button type="button" class="btn btn-orange btn-film" onclick="changeDet('OPEN','<%=iMediaLink %>');" style="display: block;"><span class="ic-deco">
          <img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt=""></span>영상보기</button>
        <button type="button" class="btn btn-orange btn-record" style="display: none;" onclick="changeDet('CLOSE','');">기록보기</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" onclick="changeDet('CLOSE','');">닫기</button>
      </div>
    </div>
  </div>
</div>

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

  if (iPlayerResultName != "") {

    var iPlayerResultName = "<%=iPlayerResultName%>";
    var iLRPlayerType = "<%=iLRPlayerType%>";

    // 승 이미지
    if (iLRPlayerType == "LPlayer") {
      $('#iLWImg').removeClass('disp-none');
      $('#iLWImg').addClass('disp-win');
    }
    else {
      $('#iRWImg').removeClass('disp-none');
      $('#iRWImg').addClass('disp-win');
    }

    //iLRPlayerType = "A";

    //alert(iLRPlayerType);

    if (iPlayerResultName == "승(반칙)") {
      if (iLRPlayerType == "LPlayer") {
        //$("#DP_L_GameResult").append("<option value=''>반칙승</option>");
        $("#DP_L_GameResult").html("반칙승");
      }
      else {
        //$("#DP_R_GameResult").append("<option value=''>반칙승</option>");
        $("#DP_R_GameResult").html("반칙승");
      }
    }
    else if (iPlayerResultName == "승(실격)") {
      if (iLRPlayerType == "LPlayer") {
        //$("#DP_L_GameResult").append("<option value=''>실격승</option>");
        $("#DP_L_GameResult").html("실격승");
      }
      else {
        //$("#DP_R_GameResult").append("<option value=''>실격승</option>");
        $("#DP_R_GameResult").html("실격승");
      }
    }
    else if (iPlayerResultName == "승(부전)") {
      if (iLRPlayerType == "LPlayer") {
        //$("#DP_L_GameResult").append("<option value=''>부전승</option>");
        $("#DP_L_GameResult").html("부전승");
      }
      else {
        //$("#DP_R_GameResult").append("<option value=''>부전승</option>");
        $("#DP_R_GameResult").html("부전승");
      }
    }
    else if (iPlayerResultName == "승(기권)") {
      if (iLRPlayerType == "LPlayer") {
        //$("#DP_L_GameResult").append("<option value=''>기권승</option>");
        $("#DP_L_GameResult").html("기권승");
      }
      else {
        //$("#DP_R_GameResult").append("<option value=''>기권승</option>");
        $("#DP_R_GameResult").html("기권승");
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
