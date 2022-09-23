<!--#include file="../Library/ajax_config.asp"-->
<%
  Check_Login()
  
  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  GroupGameGb = fInject(Request("GroupGameGb"))
  TeamGb = fInject(Request("TeamGb"))
  Level = fInject(Request("Level"))
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 


  igroupgamegbname = fInject(Request("igroupgamegbname"))
  iteamgbname = fInject(Request("iteamgbname"))
  ilevelnamename = fInject(Request("ilevelnamename"))
  

  PlayerIDX = ""
  
  Dim iYearSDate
  iYearSDate = MID(SDate,1,4)

  'Team = decode(Team,0)
  'PlayerIDX = decode(PlayerIDX,0)

  if GroupGameGb = "sd040001" then

  else
    Level = ""
  end if

  '- iType
  '1 : 선수분석 검색부분 > 대회명

  Dim LRsCnt1, iGameS1, iGameE1
  LRsCnt1 = 0

  iType = "1"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','" & GroupGameGb & "','" & PlayerIDX & "','" & TeamGb & "','" & Level & "','',''"
  'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
    Do Until LRs.Eof
      
        LRsCnt1 = LRsCnt1 + 1
        'iGameTitleIDX1 = iGameTitleIDX1&"^"&LRs("GameTitleIDX")&""
        'iGameTitleIDXCnt1 = iGameTitleIDXCnt1&"^"&LRs("GameTitleIDXCnt")&""
        'iGameTitleName1 = iGameTitleName1&"^"&LRs("GameTitleName")&""
        'iGameS1 = iGameS1&"^"&LRs("GameS")&""
        'iGameE1 = iGameE1&"^"&LRs("GameE")&""

      if LRs("GameS") <> "" then
        iGameS1arr = Split(LRs("GameS"), "-")
      end if

      if LRs("GameE") <> "" then
        iGameE1arr = Split(LRs("GameE"), "-")
      end if
%>

<!-- S: match-list -->
<div class="match-list">
	<section>
		<div class="match-day">
			<h3><span><%=iGameS1arr(1) %>/<%=iGameS1arr(2) %>~<%=iGameE1arr(1) %>/<%=iGameE1arr(2) %></span><span><%=LRs("GameTitleName") %></span></h3>
			<div class="medal-list flex" id="<%=LRs("GameTitleIDX") %>">
        <% 
          if LRs("GameTitleIDXCnt") < 4 then

          Dim GCnt
          GCnt = 0
            
          GCnt = 4 - CInt(LRs("GameTitleIDXCnt"))

          for i=1 to GCnt step 1
        %>
        <dl></dl>
        <%
          next  
          end if 
        %>
			</div>
		</div>
	</section>
</div>
<!-- E: match-list -->

<%
      LRs.MoveNext
    Loop

  Else
%>
<script type="text/javascript">
  fn_null();
</script>
<%
  End If 

  LRs.Close



  Dim LRsCnt2, iGameScoreIDX2, iGameTitleIDX2, iTeamNm2, iTitleResultName2, iPlayerIDX2, iUserName2
  LRsCnt2 = 0

  iType = "2"
  'iSportsGb = "judo"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','" & GroupGameGb & "','" & PlayerIDX & "','" & TeamGb & "','" & Level & "','',''"
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
        
      LRs.MoveNext
    Loop

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

    var iGameScoreIDX2arr = iGameScoreIDX2.split("^");
    var iGameTitleIDX2arr = iGameTitleIDX2.split("^");
    var iTeamNm2arr = iTeamNm2.split("^");
    var iTitleResultName2arr = iTitleResultName2.split("^");
    var iPlayerIDX2arr = iPlayerIDX2.split("^");
    var iUserName2arr = iUserName2.split("^");

    var GroupGameGb = "<%=GroupGameGb%>";


    for (var i = 1; i < LRsCnt2 + 1; i++) {

      var iHtmlSum2 = "";

      if (GroupGameGb == "sd040001") {
        iHtmlSum2 = iHtmlSum2 + '<a href="javascript:;" onclick="javascript:iMovieLink(&#39;' + iGameScoreIDX2arr[i] + '&#39;,&#39;' + GroupGameGb + '&#39;,&#39;' + iPlayerIDX2arr[i] + '&#39;)" data-toggle="modal" data-target=".film-modal">';
      }
      else {
        iHtmlSum2 = iHtmlSum2 + '<a href="javascript:;" onclick="javascript:iMovieLink(&#39;' + iGameScoreIDX2arr[i] + '&#39;,&#39;' + GroupGameGb + '&#39;,&#39;' + iPlayerIDX2arr[i] + '&#39;)" data-toggle="modal" data-target=".groups-res">';
      }
      
      iHtmlSum2 = iHtmlSum2 + '	 <dl>';

      if (iTitleResultName2arr[i] == "금메달") {
        iHtmlSum2 = iHtmlSum2 + '		 <dt class="golden">금메달</dt>';
      }
      else if (iTitleResultName2arr[i] == "은메달") {
        iHtmlSum2 = iHtmlSum2 + '		 <dt class="silver">은메달</dt>';
      }
      else {
        iHtmlSum2 = iHtmlSum2 + '		 <dt class="bronze">동메달</dt>';
      }

      iHtmlSum2 = iHtmlSum2 + '		 <dd>';

      if (iUserName2arr[i].length > 4) {
        iHtmlSum2 = iHtmlSum2 + '			 <p class="name">' + iUserName2arr[i].substring(0,5) + '</p>';
      }
      else {
        iHtmlSum2 = iHtmlSum2 + '			 <p class="name">' + iUserName2arr[i] + '</p>';
      }

      if (GroupGameGb == "sd040001") {

        if (iTeamNm2arr[i].length > 5) {
          iHtmlSum2 = iHtmlSum2 + '			 <p class="group">' + iTeamNm2arr[i].substring(0,6) + '</p>';
        }
        else {
          iHtmlSum2 = iHtmlSum2 + '			 <p class="group">' + iTeamNm2arr[i] + '</p>';
        }

      }

      iHtmlSum2 = iHtmlSum2 + '	   </dd>';
      iHtmlSum2 = iHtmlSum2 + '  </dl>';
      iHtmlSum2 = iHtmlSum2 + '</a>';

      $('#' + iGameTitleIDX2arr[i]).prepend(iHtmlSum2);

    }

  }

</script>