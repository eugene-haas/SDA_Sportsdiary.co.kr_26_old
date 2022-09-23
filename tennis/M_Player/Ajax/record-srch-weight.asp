<!--#include file="../Library/ajax_config.asp"-->
<%
  Check_Login()
  
  SDate = fInject(Request("SDate"))
  EDate = fInject(Request("EDate"))
  MatchTitle = fInject(Request("MatchTitle"))
  
  Dim iYearSDate
  iYearSDate = MID(SDate,1,4)

  '- iType
  '1 : 선수분석 검색부분 > 대회명

  Dim LRsCnt1, iGameS1, iGameE1
  LRsCnt1 = 0

  iType = "61"
  iSportsGb = "judo"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','','','','','','" & MatchTitle & "'"
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
			<h3><span><% if LRs("GroupGameGb") = "sd040001" then %><%=LRs("LevelName") %><% else %><%=LRs("GroupGameGbName") %><% end if %></span><span><%=LRs("TeamGbName") %> / <%=LRs("GroupGameGbName") %></span></h3>
			<% if LRs("GroupGameGb") = "sd040001" then %>
      <div class="medal-list flex" id="<%=LRs("Level") %>">
      <% else %>
      <div class="medal-list flex" id="<%=LRs("TeamGb") %>">
      <% end if %>
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

  iType = "62"
  'iSportsGb = "judo"

  LSQL = "EXEC Record_Winner_Search '" & iType & "','" & iSportsGb & "','" & SDate & "','" & EDate & "','','','','','','" & MatchTitle & "'"
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

        iLevel2 = iLevel2&"^"&LRs("Level")&""
        iTeamGb2 = iTeamGb2&"^"&LRs("TeamGb")&""
        iGroupGameGb2 = iGroupGameGb2&"^"&LRs("GroupGameGb")&""
        
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

    var iLevel2 = "<%=iLevel2%>";
    var iTeamGb2 = "<%=iTeamGb2%>";
    var iGroupGameGb2 = "<%=iGroupGameGb2%>";

    var iGameScoreIDX2arr = iGameScoreIDX2.split("^");
    var iGameTitleIDX2arr = iGameTitleIDX2.split("^");
    var iTeamNm2arr = iTeamNm2.split("^");
    var iTitleResultName2arr = iTitleResultName2.split("^");
    var iPlayerIDX2arr = iPlayerIDX2.split("^");
    var iUserName2arr = iUserName2.split("^");
    
    var iLevel2arr = iLevel2.split("^");
    var iTeamGb2arr = iTeamGb2.split("^");
    var iGroupGameGb2arr = iGroupGameGb2.split("^");


    for (var i = 1; i < LRsCnt2 + 1; i++) {

      var iHtmlSum2 = "";

      if (iGroupGameGb2arr[i] == "sd040001") {
        iHtmlSum2 = iHtmlSum2 + '<a href="javascript:;" onclick="javascript:iMovieLink(&#39;' + iGameScoreIDX2arr[i] + '&#39;,&#39;' + iGroupGameGb2arr[i] + '&#39;,&#39;' + iPlayerIDX2arr[i] + '&#39;)" data-toggle="modal" data-target=".film-modal">';
      }
      else {
        iHtmlSum2 = iHtmlSum2 + '<a href="javascript:;" onclick="javascript:iMovieLink(&#39;' + iGameScoreIDX2arr[i] + '&#39;,&#39;' + iGroupGameGb2arr[i] + '&#39;,&#39;' + iPlayerIDX2arr[i] + '&#39;)" data-toggle="modal" data-target=".groups-res">';
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

      if (iGroupGameGb2arr[i] == "sd040001") {

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

      //$('#' + iGameTitleIDX2arr[i]).prepend(iHtmlSum2);
      if (iGroupGameGb2arr[i] == "sd040001") {
        $('#' + iLevel2arr[i]).prepend(iHtmlSum2);
      }
      else {
        $('#' + iTeamGb2arr[i]).prepend(iHtmlSum2);
      }

    }

  }

</script>