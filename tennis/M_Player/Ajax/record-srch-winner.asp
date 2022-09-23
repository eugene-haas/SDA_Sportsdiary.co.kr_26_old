<!--#include file="../Library/ajax_config.asp"-->
<%
  Check_Login()

  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  GroupGameGb = fInject(Request("GroupGameGb"))
  TeamGb = fInject(Request("TeamGb"))
  Level = fInject(Request("Level"))
  Selschgubun = fInject(Request("Selschgubun"))
  Txtname = fInject(Request("Txtname"))


 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType")

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가


  Dim iYearSDate
  iYearSDate = MID(SDate,1,4)

	'Team = decode(Team,0)
  if Selschgubun = "schuser" then
	Txtname = decode(Txtname,0)
  end if

  '- iType
  '1 : 선수분석 검색부분 > 대회명


  Dim LRsCnt2, iGameScoreIDX2, iGameTitleIDX2, iTeamNm2, iTitleResultName2, iPlayerIDX2, iUserName2, iTeamGbName2, iLevelName2, iGroupGameGbName2, iGroupGameGb2
  LRsCnt2 = 0

  iType = "3"
  'iSportsGb = "judo"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','" & GroupGameGb & "','" & PlayerIDX & "','" & TeamGb & "','" & Level & "','" & Selschgubun & "','" & Txtname & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1
        iGameScoreIDX2 = iGameScoreIDX2&"^"&LRs("GameScoreIDX")&""
        iGameTitleIDX2 = iGameTitleIDX2&"^"&LRs("GameTitleIDX")&""
        iTeamNm2 = iTeamNm2&"^"&LRs("TeamNm")&""
        iTitleResultName2 = iTitleResultName2&"^"&LRs("TitleResultName")&""
        iPlayerIDX2 = iPlayerIDX2&"^"&encode(LRs("PlayerIDX"),0)&""
        iUserName2 = iUserName2&"^"&LRs("UserName")&""
        iTeamGbName2 = iTeamGbName2&"^"&LRs("TeamGbName")&""
        iLevelName2 = iLevelName2&"^"&LRs("LevelName")&""
        iGroupGameGb2 = iGroupGameGb2&"^"&LRs("GroupGameGb")&""
        iGroupGameGbName2 = iGroupGameGbName2&"^"&LRs("GroupGameGbName")&""

      LRs.MoveNext
    Loop

  End If

  LRs.Close


  if LRsCnt2 > 0 and Selschgubun = "schuser" then

    Dim LRsCnt3, iPlayerIDX3, iUserName3, iBirthday3, iPhotoPath3
    LRsCnt3 = 0

    iType = "6"
    'iSportsGb = "judo"

    LSQL = "EXEC Record_Search '" & iType & "','" & iSportsGb & "','','','','','" & Txtname & "'"
    'response.Write "LSQL="&LSQL&"<br>"
    'response.End
	  Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
      Do Until LRs.Eof

          LRsCnt3 = LRsCnt3 + 1

          iPlayerIDX3 = LRs("PlayerIDX")
          iUserName3 = LRs("UserName")
          iBirthday3 = LRs("Birthday")
          iPhotoPath3 = LRs("PhotoPath")


        LRs.MoveNext
      Loop

    End If

    LRs.Close

  end if



  Dim LRsCnt1, iGameS1, iGameE1
  LRsCnt1 = 0

  iType = "4"
  'iSportsGb = "judo"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','" & GroupGameGb & "','" & PlayerIDX & "','" & TeamGb & "','" & Level & "','" & Selschgubun & "','" & Txtname & "'"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
%>
<h2>
	<span><%=iYearSDate %>년</span> /
  <% if iPhotoPath3 = "" and Selschgubun = "schteam" then %>
    <span><%=Txtname %></span>
  <% elseif iPhotoPath3 = "" and Selschgubun = "schuser" then %>
    <span class="icon-img">
      <img src="http://img.sportsdiary.co.kr/sdapp/record/srch-default@3x.png" alt="" />
	  </span>
    <span><%=iUserName3 %></span><span>(<%=MID(iBirthday3,3) %>)</span>
  <% else %>
    <span class="icon-img">
			<img src="../<%=MID(iPhotoPath3,4) %>" alt="" />
		</span>
    <span><%=iUserName3 %></span><span>(<%=MID(iBirthday3,3) %>)</span>
  <% end if %>
</h2>
<!-- S: match-list -->
<div class="match-list">
<%
    Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1

        if LRs("GameS") <> "" then
          iGameS1arr = Split(LRs("GameS"), "-")
        end if

        if LRs("GameE") <> "" then
          iGameE1arr = Split(LRs("GameE"), "-")
        end if

%>
  <!-- S: section -->
	<section id="<%=LRs("GameTitleIDX") %>">
		<h3><span><%=Mid(LRs("GameS"),6,2) %>/<%=Mid(LRs("GameS"),9) %>~<%=Mid(LRs("GameE"),6,2) %>/<%=Mid(LRs("GameE"),9) %></span><span><%=LRs("GameTitleName") %></span></h3>

	</section>
	<!-- E: section -->
<%

      LRs.MoveNext
    Loop
%>
  <!-- E: section -->
</div>
<!-- E: match-list -->
<%
  End If

  LRs.Close


  Dbclose()
%>
<script type="text/javascript">

  var LRsCnt2 = Number("<%=LRsCnt2%>");

  if (LRsCnt2 > 0) {

    var iGameScoreIDX2 = "<%=iGameScoreIDX2%>";
    var iGameTitleIDX2 = "<%=iGameTitleIDX2%>";
    var iTeamNm2 = "<%=iTeamNm2%>";
    var iTitleResultName2 = "<%=iTitleResultName2%>";
    var iPlayerIDX2 = "<%=iPlayerIDX2%>";
    var iUserName2 = "<%=iUserName2%>";
    var iTeamGbName2 = "<%=iTeamGbName2%>";
    var iLevelName2 = "<%=iLevelName2%>";
    var iGroupGameGbName2 = "<%=iGroupGameGbName2%>";
    var iGroupGameGb2 = "<%=iGroupGameGb2%>";

    var iGameScoreIDX2arr = iGameScoreIDX2.split("^");
    var iGameTitleIDX2arr = iGameTitleIDX2.split("^");
    var iTeamNm2arr = iTeamNm2.split("^");
    var iTitleResultName2arr = iTitleResultName2.split("^");
    var iPlayerIDX2arr = iPlayerIDX2.split("^");
    var iUserName2arr = iUserName2.split("^");
    var iTeamGbName2arr = iTeamGbName2.split("^");
    var iLevelName2arr = iLevelName2.split("^");
    var iGroupGameGbName2arr = iGroupGameGbName2.split("^");
    var iGroupGameGb2arr = iGroupGameGb2.split("^");


    for (var i = 1; i < LRsCnt2 + 1; i++) {

      var iHtmlSum2 = "";

      if (iTitleResultName2arr[i] == "금메달") {
        iHtmlSum2 = iHtmlSum2 + '<dl class="match-res golden clearfix">';
      }
      else if (iTitleResultName2arr[i] == "은메달") {
        iHtmlSum2 = iHtmlSum2 + '<dl class="match-res silver clearfix">';
      }
      else {
        iHtmlSum2 = iHtmlSum2 + '<dl class="match-res bronze clearfix">';
      }

      if (iGroupGameGbName2arr[i] == "개인전") {
        iHtmlSum2 = iHtmlSum2 + '<dt><a href="javascript:;" onclick="javascript:iMovieLink(&#39;' + iGameScoreIDX2arr[i] + '&#39;,&#39;' + iGroupGameGb2arr[i] + '&#39;,&#39;' + iPlayerIDX2arr[i] + '&#39;)" data-toggle="modal" data-target=".film-modal">' + iTitleResultName2arr[i] + '</a></dt>';
      }
      else {
        iHtmlSum2 = iHtmlSum2 + '<dt><a href="javascript:;" onclick="javascript:iMovieLink(&#39;' + iGameScoreIDX2arr[i] + '&#39;,&#39;' + iGroupGameGb2arr[i] + '&#39;,&#39;' + iPlayerIDX2arr[i] + '&#39;)" data-toggle="modal" data-target=".groups-res">' + iTitleResultName2arr[i] + '</a></dt>';
      }

      if (iGroupGameGbName2arr[i] == "개인전") {
        iHtmlSum2 = iHtmlSum2 + '<dd><span>' + iTeamGbName2arr[i] + '</span><span>' + iGroupGameGbName2arr[i] + '</span><span>' + iUserName2arr[i] + '</span><span>' + iLevelName2arr[i] + '</span><span>' + iTeamNm2arr[i] + '</span></dd>';
      }
      else {
        iHtmlSum2 = iHtmlSum2 + '<dd><span>' + iTeamGbName2arr[i] + '</span><span>' + iGroupGameGbName2arr[i] + '</span><span>' + iTeamNm2arr[i] + '</span></dd>';
      }

      iHtmlSum2 = iHtmlSum2 + '</dl>';

      $('#' + iGameTitleIDX2arr[i]).append(iHtmlSum2);

    }

  }

</script>
