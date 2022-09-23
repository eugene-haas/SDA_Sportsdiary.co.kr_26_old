<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()

	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))

	iPlayerIDX = decode(iPlayerIDX,0)

 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType")

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가


	Dim LRsCnt2, iGameTitleIDX2, iGroupGameGb2, iGroupGameGbNm2
	LRsCnt2 = 0

	iType = "2"
	'iSportsGb = "judo"

  LSQL = "EXEC Stat_Film_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1
        iGameTitleIDX2 = iGameTitleIDX2&"^"&LRs("GameTitleIDX")&""
        iGroupGameGb2 = iGroupGameGb2&"^"&LRs("GroupGameGb")&""
        iGroupGameGbNm2 = iGroupGameGbNm2&"^"&LRs("GroupGameGbNm")&""

      LRs.MoveNext
		Loop
  else

	End If

  LRs.close



  Dim LRsCnt3, iPlayerResultIdx3, iGameTitleIDX3, iLeftUser3, iRightUser3, iLeftTeamNm3, iRightTeamNm3, iResult3, iResultWin3, iTopRoundNm3, iLevelNm3, iMediaLink3
  LRsCnt3 = 0

  iType = "3"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Film_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt3 = LRsCnt3 + 1
        iPlayerResultIdx3 = iPlayerResultIdx3&"^"&LRs("PlayerResultIdx")&""
        iGameTitleIDX3 = iGameTitleIDX3&"^"&LRs("GameTitleIDX")&""
        iLeftUser3 = iLeftUser3&"^"&LRs("LeftUser")&""
        iRightUser3 = iRightUser3&"^"&LRs("RightUser")&""
        iLeftTeamNm3 = iLeftTeamNm3&"^"&LRs("LeftTeamNm")&""
        iRightTeamNm3 = iRightTeamNm3&"^"&LRs("RightTeamNm")&""
        iResult3 = iResult3&"^"&LRs("Result")&""
        iResultWin3 = iResultWin3&"^"&LRs("ResultWin")&""
        iTopRoundNm3 = iTopRoundNm3&"^"&LRs("TopRoundNm")&""
        iLevelNm3 = iLevelNm3&"^"&LRs("LevelNm")&""
        iMediaLink3 = iMediaLink3&"^"&LRs("MediaLink")&""

      LRs.MoveNext
		Loop
  else

	End If

  LRs.close



  Dim LRsCnt4, iPlayerResultIdx4, iGameTitleIDX4, iLeftUser4, iRightUser4, iLeftTeamNm4, iRightTeamNm4, iResult4, iResultWin4, iTopRoundNm4, iMediaLink4
  LRsCnt4 = 0

  iType = "4"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Film_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt4 = LRsCnt4 + 1
        iPlayerResultIdx4 = iPlayerResultIdx4&"^"&LRs("PlayerResultIdx")&""
        iGameTitleIDX4 = iGameTitleIDX4&"^"&LRs("GameTitleIDX")&""
        iLeftUser4 = iLeftUser4&"^"&LRs("LeftUser")&""
        iRightUser4 = iRightUser4&"^"&LRs("RightUser")&""
        iLeftTeamNm4 = iLeftTeamNm4&"^"&LRs("LeftTeamNm")&""
        iRightTeamNm4 = iRightTeamNm4&"^"&LRs("RightTeamNm")&""
        iResult4 = iResult4&"^"&LRs("Result")&""
        iResultWin4 = iResultWin4&"^"&LRs("ResultWin")&""
        iTopRoundNm4 = iTopRoundNm4&"^"&LRs("TopRoundNm")&""
        iMediaLink4 = iMediaLink4&"^"&LRs("MediaLink")&""

      LRs.MoveNext
		Loop
  else

	End If

  LRs.close



  Dim LRsCnt1, iGameTitleName1, iGameS1, iGameE1, iGameTitleIDX1
  LRsCnt1 = 0

  iType = "1"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Film_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End

  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
%>
<div class="stat-film-title">
  <p class="stat-year container"><%=Left(SDate,4)&"년" %></p>
</div>
<%
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        iGameTitleIDX1 = LRs("GameTitleIDX")
        iGameTitleName1 = LRs("GameTitleName")
        iGameS1 = LRs("GameS")
        iGameE1 = LRs("GameE")
%>
<div class="stat-film-title">
  <h3><%=iGameTitleName1 %> <span>대회기간: <%=iGameS1 %> ~ <%=iGameE1 %></span></h3>
</div>

<div id="P_<%=iGameTitleIDX1 %>"></div>


<div id="T_<%=iGameTitleIDX1 %>"></div>


<%

      LRs.MoveNext
		Loop
  else
%>

<script type="text/javascript">
  alert("검색 조건으로 조회된 데이터가 없습니다.")
  $('.bg-inst').show();
</script>

<%
	End If

  LRs.close

  Dbclose()

%>

<script type="text/javascript">

  // 개인전 , 단체전 추가
  var TCnt2 = Number("<%=LRsCnt2%>");

  if (TCnt2 > 0) {

    var iGameTitleIDX2 = "<%=iGameTitleIDX2%>";
    var iGroupGameGb2 = "<%=iGroupGameGb2%>";
    var iGroupGameGbNm2 = "<%=iGroupGameGbNm2%>";

    //alert("TCnt2:" + TCnt2 + "\r\n" + "iGameTitleIDX2:" + iGameTitleIDX2 + "\r\n" + "iGroupGameGb2:" + iGroupGameGb2 + "\r\n");

    var iGameTitleIDX2arr = iGameTitleIDX2.split("^");
    var iGroupGameGb2arr = iGroupGameGb2.split("^");
    var iGroupGameGbNm2arr = iGroupGameGbNm2.split("^");

    var iHtmlP = "";
    var iHtmlT = "";

    for (var i = 1; i < TCnt2 + 1; i++) {

      if (iGroupGameGbNm2arr[i] == "개인전") {

        iHtmlP = '<!-- S: 개인전 stat-film -->';
        iHtmlP = iHtmlP + '<section class="stat-film">';
        iHtmlP = iHtmlP + '  <div class="div-title">';
        iHtmlP = iHtmlP + '    <h4>개인전</h4>';
        iHtmlP = iHtmlP + '    <!-- <p class="list-info"><span>개인전</span><span>고등부</span><span>남자 -66kg</span></p> -->';
        iHtmlP = iHtmlP + '  </div>';
        iHtmlP = iHtmlP + '  <!-- S: container -->';
        iHtmlP = iHtmlP + '  <div class="ana container" id="P_' + iGameTitleIDX2arr[i] + '_' + iGroupGameGb2arr[i] + '">';
        iHtmlP = iHtmlP + '  </div>';
        iHtmlP = iHtmlP + '  <!-- E: container -->';
        iHtmlP = iHtmlP + '</section>';
        iHtmlP = iHtmlP + '<!-- E: 개인전 stat-film -->';

        $('#P_' + iGameTitleIDX2arr[i]).append(iHtmlP);
      }
      else {

        iHtmlT = '<!-- S: 단체전 stat-film -->';
        iHtmlT = iHtmlT + '<section class="stat-film group">';
        iHtmlT = iHtmlT + '  <div class="div-title">';
        iHtmlT = iHtmlT + '    <h4>단체전</h4>';
        iHtmlT = iHtmlT + '    <!-- <p class="list-info"><span>단체전</span><span>고등부</span><span>남자</span></p> -->';
        iHtmlT = iHtmlT + '  </div>';
        iHtmlT = iHtmlT + '  <!-- S: container -->';
        iHtmlT = iHtmlT + '  <div class="ana container" id="T_' + iGameTitleIDX2arr[i] + '_' + iGroupGameGb2arr[i] + '">';
        iHtmlT = iHtmlT + '  </div>';
        iHtmlT = iHtmlT + '  <!-- E: container -->';
        iHtmlT = iHtmlT + '</section>';
        iHtmlT = iHtmlT + '<!-- E: 단체전 stat-film -->';

        $('#T_' + iGameTitleIDX2arr[i]).append(iHtmlT);
      }

    }

  }



  // 개인전 내용 추가
  var TCnt3 = Number("<%=LRsCnt3%>");

  if (TCnt3 > 0) {

    var iPlayerResultIdx3 = "<%=iPlayerResultIdx3%>";
    var iGameTitleIDX3 = "<%=iGameTitleIDX3%>";
    var iLeftUser3 = "<%=iLeftUser3%>";
    var iRightUser3 = "<%=iRightUser3%>";
    var iLeftTeamNm3 = "<%=iLeftTeamNm3%>";
    var iRightTeamNm3 = "<%=iRightTeamNm3%>";
    var iResult3 = "<%=iResult3%>";
    var iResultWin3 = "<%=iResultWin3%>";
    var iTopRoundNm3 = "<%=iTopRoundNm3%>";
    var iLevelNm3 = "<%=iLevelNm3%>";

    //alert("TCnt2:" + TCnt2 + "\r\n" + "iGameTitleIDX2:" + iGameTitleIDX2 + "\r\n" + "iGroupGameGb2:" + iGroupGameGb2 + "\r\n");

    var iPlayerResultIdx3arr = iPlayerResultIdx3.split("^");
    var iGameTitleIDX3arr = iGameTitleIDX3.split("^");
    var iLeftUser3arr = iLeftUser3.split("^");
    var iRightUser3arr = iRightUser3.split("^");
    var iLeftTeamNm3arr = iLeftTeamNm3.split("^");
    var iRightTeamNm3arr = iRightTeamNm3.split("^");
    var iResult3arr = iResult3.split("^");
    var iResultWin3arr = iResultWin3.split("^");
    var iTopRoundNm3arr = iTopRoundNm3.split("^");
    var iLevelNm3arr = iLevelNm3.split("^");

    var iHtmlPC = "";

    for (var i = 1; i < TCnt3 + 1; i++) {

      if (iTopRoundNm3arr[i] == "2") {
        iTopRoundNm3arr[i] = "결승";
      }
      else if (iTopRoundNm3arr[i] == "4") {
        iTopRoundNm3arr[i] = "준결승";
      }
      else {
        iTopRoundNm3arr[i] = iTopRoundNm3arr[i] + "강";
      }

      iHtmlPC = '<!-- S: stat-list -->';
      iHtmlPC = iHtmlPC + '<dl class="stat-list">';
      iHtmlPC = iHtmlPC + '  <dt>';
      iHtmlPC = iHtmlPC + '    <!--<a href="#" class="icon-favorite on">★</a>-->';
      iHtmlPC = iHtmlPC + '    <!--<a href="#" class="icon-favorite">★</a>-->';
      iHtmlPC = iHtmlPC + '    <span>' + iTopRoundNm3arr[i] + ' (' + iLevelNm3arr[i] + ')</span>';
      iHtmlPC = iHtmlPC + '    <a href="#" onclick="javascript:iMovieLink(&#39;' + iPlayerResultIdx3arr[i] + '&#39;,&#39;개인전&#39;);" class="show-film" data-target="#show-score" data-toggle="modal"><img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt="대회영상보기"></a>';
      iHtmlPC = iHtmlPC + '  </dt>';
      iHtmlPC = iHtmlPC + '  <dd>';
      iHtmlPC = iHtmlPC + '    <ul>';
      iHtmlPC = iHtmlPC + '      <li class="clearfix">';
      iHtmlPC = iHtmlPC + '        <p class="me">' + iLeftUser3arr[i];

      if (iResultWin3arr[i] == "LWIN") {
        iHtmlPC = iHtmlPC + '/' + iResult3arr[i] + '<span class="school">' + iLeftTeamNm3arr[i] + '</span></p>';
      }
      else {
        iHtmlPC = iHtmlPC + '<span class="school">' + iLeftTeamNm3arr[i] + '</span></p>';
      }

      iHtmlPC = iHtmlPC + '        <p class="vs">VS</p>';
      iHtmlPC = iHtmlPC + '        <p class="you">' + iRightUser3arr[i];

      if (iResultWin3arr[i] == "LWIN") {
        iHtmlPC = iHtmlPC + '<span class="school">' + iRightTeamNm3arr[i] + '</span></p>';
      }
      else {
        iHtmlPC = iHtmlPC + '/' + iResult3arr[i] + '<span class="school">' + iRightTeamNm3arr[i] + '</span></p>';
      }

      iHtmlPC = iHtmlPC + '      </li>';
      iHtmlPC = iHtmlPC + '    </ul>';
      iHtmlPC = iHtmlPC + '  </dd>';
      iHtmlPC = iHtmlPC + '</dl>';
      iHtmlPC = iHtmlPC + '<!-- E: stat-list -->';

      $('#P_' + iGameTitleIDX3arr[i] + "_sd040001").append(iHtmlPC);

    }

  }


  // 단체전 내용 추가
  var TCnt4 = Number("<%=LRsCnt4%>");

  if (TCnt4 > 0) {

    var iPlayerResultIdx4 = "<%=iPlayerResultIdx4%>";
    var iGameTitleIDX4 = "<%=iGameTitleIDX4%>";
    var iLeftUser4 = "<%=iLeftUser4%>";
    var iRightUser4 = "<%=iRightUser4%>";
    var iLeftTeamNm4 = "<%=iLeftTeamNm4%>";
    var iRightTeamNm4 = "<%=iRightTeamNm4%>";
    var iResult4 = "<%=iResult4%>";
    var iResultWin4 = "<%=iResultWin4%>";
    var iTopRoundNm4 = "<%=iTopRoundNm4%>";

    //alert("TCnt2:" + TCnt2 + "\r\n" + "iGameTitleIDX2:" + iGameTitleIDX2 + "\r\n" + "iGroupGameGb2:" + iGroupGameGb2 + "\r\n");

    var iPlayerResultIdx4arr = iPlayerResultIdx4.split("^");
    var iGameTitleIDX4arr = iGameTitleIDX4.split("^");
    var iLeftUser4arr = iLeftUser4.split("^");
    var iRightUser4arr = iRightUser4.split("^");
    var iLeftTeamNm4arr = iLeftTeamNm4.split("^");
    var iRightTeamNm4arr = iRightTeamNm4.split("^");
    var iResult4arr = iResult4.split("^");
    var iResultWin4arr = iResultWin4.split("^");
    var iTopRoundNm4arr = iTopRoundNm4.split("^");

    var iHtmlTC = "";

    for (var i = 1; i < TCnt4 + 1; i++) {

      if (iTopRoundNm4arr[i] == "2") {
        iTopRoundNm4arr[i] = "결승";
      }
      else if (iTopRoundNm4arr[i] == "4") {
        iTopRoundNm4arr[i] = "준결승";
      }
      else {
        iTopRoundNm4arr[i] = iTopRoundNm4arr[i] + "강";
      }

      iHtmlTC = '<!-- S: stat-list -->';
      iHtmlTC = iHtmlTC + '<dl class="stat-list">';
      iHtmlTC = iHtmlTC + '  <dt>';
      iHtmlTC = iHtmlTC + '    <!--<a href="#" class="icon-favorite">★</a>-->';
      iHtmlTC = iHtmlTC + '    <span>' + iTopRoundNm4arr[i] + '</span>';
      iHtmlTC = iHtmlTC + '    <a href="#" onclick="javascript:iMovieLink(&#39;' + iPlayerResultIdx4arr[i] + '&#39;,&#39;단체전&#39;);" class="show-film" data-target="#groupround-res" data-toggle="modal"><img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt="대회영상보기"></a>';
      iHtmlTC = iHtmlTC + '  </dt>';
      iHtmlTC = iHtmlTC + '  <dd>';
      iHtmlTC = iHtmlTC + '    <ul>';
      iHtmlTC = iHtmlTC + '      <li class="clearfix">';
      iHtmlTC = iHtmlTC + '        <p class="me"><span class="school">' + iLeftTeamNm4arr[i];

      if (iResultWin4arr[i] == "LWIN") {
        iHtmlTC = iHtmlTC + '/' + iResult4arr[i] + '</span></p>';
      }
      else {
        iHtmlTC = iHtmlTC + '</span></p>';
      }

      iHtmlTC = iHtmlTC + '        <p class="vs">VS</p>';
      iHtmlTC = iHtmlTC + '        <p class="you"><span class="school">' + iRightTeamNm4arr[i];

      if (iResultWin4arr[i] == "LWIN") {
        iHtmlTC = iHtmlTC + '</span></p>';
      }
      else {
        iHtmlTC = iHtmlTC + '/' + iResult4arr[i] + '</span></p>';
      }

      iHtmlTC = iHtmlTC + '      </li>';
      iHtmlTC = iHtmlTC + '    </ul>';
      iHtmlTC = iHtmlTC + '  </dd>';
      iHtmlTC = iHtmlTC + '</dl>';
      iHtmlTC = iHtmlTC + '<!-- E: stat-list -->';

      $('#T_' + iGameTitleIDX4arr[i] + "_sd040002").append(iHtmlTC);

    }

  }


</script>
