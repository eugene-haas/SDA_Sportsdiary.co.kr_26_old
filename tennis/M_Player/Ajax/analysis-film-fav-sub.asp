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

	
	Dim LRsCnt1, iPlayerResultIdx1, iGameTitleIDX1, iLeftUser1, iRightUser1, iLeftTeamNm1, iRightTeamNm1, iResult1, iResultWin1, iTopRoundNm1, iMediaLink1, iGameS1, iGameE1, iGameTitleName1
	LRsCnt1 = 0
	
	iType = "1"
	'iSportsGb = "judo"
  
  LSQL = "EXEC Analysis_Fav_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)
  
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
  
        LRsCnt1 = LRsCnt1 + 1
        iPlayerResultIdx1 = iPlayerResultIdx1&"^"&LRs("PlayerResultIdx")&""
        iGameTitleIDX1 = iGameTitleIDX1&"^"&LRs("GameTitleIDX")&""
        iLeftUser1 = iLeftUser1&"^"&LRs("LeftUser")&""
        iRightUser1 = iRightUser1&"^"&LRs("RightUser")&""
        iLeftTeamNm1 = iLeftTeamNm1&"^"&LRs("LeftTeamNm")&""
        iRightTeamNm1 = iRightTeamNm1&"^"&LRs("RightTeamNm")&""
        iResult1 = iResult1&"^"&LRs("Result")&""
        iResultWin1 = iResultWin1&"^"&LRs("ResultWin")&""
        iTopRoundNm1 = iTopRoundNm1&"^"&LRs("TopRoundNm")&""
        iMediaLink1 = iMediaLink1&"^"&LRs("MediaLink")&""
        iGameS1 = iGameS1&"^"&LRs("GameS")&""
        iGameE1 = iGameE1&"^"&LRs("GameE")&""
        iGameTitleName1 = iGameTitleName1&"^"&LRs("GameTitleName")&""
  
      LRs.MoveNext
		Loop
  else
    
	End If
  
  LRs.close


  Dim LRsCnt2, iPlayerResultIdx2, iGameTitleIDX2, iLeftUser2, iRightUser2, iLeftTeamNm2, iRightTeamNm2, iResult2, iResultWin2, iTopRoundNm2, iMediaLink2, iGameS2, iGameE2, iGameTitleName2
  LRsCnt2 = 0
  
  iType = "2"
  
  LSQL = "EXEC Analysis_Fav_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)
  
  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof
  
        LRsCnt2 = LRsCnt2 + 1
        iPlayerResultIdx2 = iPlayerResultIdx2&"^"&LRs("PlayerResultIdx")&""
        iGameTitleIDX2 = iGameTitleIDX2&"^"&LRs("GameTitleIDX")&""
        iLeftUser2 = iLeftUser2&"^"&LRs("LeftUser")&""
        iRightUser2 = iRightUser2&"^"&LRs("RightUser")&""
        iLeftTeamNm2 = iLeftTeamNm2&"^"&LRs("LeftTeamNm")&""
        iRightTeamNm2 = iRightTeamNm2&"^"&LRs("RightTeamNm")&""
        iResult2 = iResult2&"^"&LRs("Result")&""
        iResultWin2 = iResultWin2&"^"&LRs("ResultWin")&""
        iTopRoundNm2 = iTopRoundNm2&"^"&LRs("TopRoundNm")&""
        iMediaLink2 = iMediaLink2&"^"&LRs("MediaLink")&""
        iGameS2 = iGameS2&"^"&LRs("GameS")&""
        iGameE2 = iGameE2&"^"&LRs("GameE")&""
        iGameTitleName2 = iGameTitleName2&"^"&LRs("GameTitleName")&""
  
      LRs.MoveNext
		Loop
  else
    
	End If
  
  LRs.close

  
  Dbclose()

%>

<% if LRsCnt1 > 0 or LRsCnt2 > 0 then %>

<div class="stat-film-title">
  <p class="stat-year container"><%=MID(SDate,1,4) %>년</p>
  <!-- <h3>제16회 제주컵 유도대회 <span>대회기간: 2016년 3월 25일 ~ 28일 (3일간)</span></h3> -->
</div>
<!-- S: stat-film -->
<section class="stat-film">
  <!-- S: container -->
  <div class="ana container">
    <ul class="stat-list" id="sub_table1_1">

    </ul>
  </div>
  <!-- E: container -->
</section>
<!-- E: stat-film -->


<script type="text/javascript">

  // 개인전 추가
  var TCnt1 = Number("<%=LRsCnt1%>");

  var iPlayerResultIdx1 = "<%=iPlayerResultIdx1%>";
  var iGameTitleIDX1 = "<%=iGameTitleIDX1%>";
  var iLeftUser1 = "<%=iLeftUser1%>";
  var iRightUser1 = "<%=iRightUser1%>";
  var iLeftTeamNm1 = "<%=iLeftTeamNm1%>";
  var iRightTeamNm1 = "<%=iRightTeamNm1%>";
  var iResult1 = "<%=iResult1%>";
  var iResultWin1 = "<%=iResultWin1%>";
  var iTopRoundNm1 = "<%=iTopRoundNm1%>";
  var iMediaLink1 = "<%=iMediaLink1%>";
  var iGameS1 = "<%=iGameS1%>";
  var iGameE1 = "<%=iGameE1%>";
  var iGameTitleName1 = "<%=iGameTitleName1%>";

  var iPlayerResultIdx1arr = iPlayerResultIdx1.split("^");
  var iGameTitleIDX1arr = iGameTitleIDX1.split("^");
  var iLeftUser1arr = iLeftUser1.split("^");
  var iRightUser1arr = iRightUser1.split("^");
  var iLeftTeamNm1arr = iLeftTeamNm1.split("^");
  var iRightTeamNm1arr = iRightTeamNm1.split("^");
  var iResult1arr = iResult1.split("^");
  var iResultWin1arr = iResultWin1.split("^");
  var iTopRoundNm1arr = iTopRoundNm1.split("^");
  var iMediaLink1arr = iMediaLink1.split("^");
  var iGameS1arr = iGameS1.split("^");
  var iGameE1arr = iGameE1.split("^");
  var iGameTitleName1arr = iGameTitleName1.split("^");


  // 단체전 추가
  var TCnt2 = Number("<%=LRsCnt2%>");

  var iPlayerResultIdx2 = "<%=iPlayerResultIdx2%>";
  var iGameTitleIDX2 = "<%=iGameTitleIDX2%>";
  var iLeftUser2 = "<%=iLeftUser2%>";
  var iRightUser2 = "<%=iRightUser2%>";
  var iLeftTeamNm2 = "<%=iLeftTeamNm2%>";
  var iRightTeamNm2 = "<%=iRightTeamNm2%>";
  var iResult2 = "<%=iResult2%>";
  var iResultWin2 = "<%=iResultWin2%>";
  var iTopRoundNm2 = "<%=iTopRoundNm2%>";
  var iMediaLink2 = "<%=iMediaLink2%>";
  var iGameS2 = "<%=iGameS2%>";
  var iGameE2 = "<%=iGameE2%>";
  var iGameTitleName2 = "<%=iGameTitleName2%>";

  var iPlayerResultIdx2arr = iPlayerResultIdx2.split("^");
  var iGameTitleIDX2arr = iGameTitleIDX2.split("^");
  var iLeftUser2arr = iLeftUser2.split("^");
  var iRightUser2arr = iRightUser2.split("^");
  var iLeftTeamNm2arr = iLeftTeamNm2.split("^");
  var iRightTeamNm2arr = iRightTeamNm2.split("^");
  var iResult2arr = iResult2.split("^");
  var iResultWin2arr = iResultWin2.split("^");
  var iTopRoundNm2arr = iTopRoundNm2.split("^");
  var iMediaLink2arr = iMediaLink2.split("^");
  var iGameS2arr = iGameS2.split("^");
  var iGameE2arr = iGameE2.split("^");
  var iGameTitleName2arr = iGameTitleName2.split("^");

  var iHtmlP = "";
  var iHtmlT = "";


  if (TCnt1 > 0) {

    for (var i = 1; i < TCnt1 + 1; i++) {

      if (iTopRoundNm1arr[i] == "2") {
        iTopRoundNm1arr[i] = "결승";
      }
      else if (iTopRoundNm1arr[i] == "4") {
        iTopRoundNm1arr[i] = "준결승";
      }
      else {
        iTopRoundNm1arr[i] = iTopRoundNm1arr[i] + "강";
      }

      iHtmlP = '<li class="clearfix">';
      iHtmlP = iHtmlP + '      <div class="video">';
      iHtmlP = iHtmlP + '        <!-- S: video-title -->';
      iHtmlP = iHtmlP + '        <div class="video-title">';
      iHtmlP = iHtmlP + '          <h3>' + iGameTitleName1arr[i] + '</h3>';
      iHtmlP = iHtmlP + '          <p>대회기간: ' + iGameS1arr[i] + '~' + iGameE1arr[i] + '</p>';
      iHtmlP = iHtmlP + '        </div>';
      iHtmlP = iHtmlP + '        <!-- E: video-title -->';
      iHtmlP = iHtmlP + '        <a href="#" class="play"><iframe width="100%" height="200" src="' + iMediaLink1arr[i] + '?rel=0" frameborder="0" allowfullscreen></iframe></a>';
      iHtmlP = iHtmlP + '      </div>';
      iHtmlP = iHtmlP + '      <p class="video-info clearfix">';
      iHtmlP = iHtmlP + '        <span class="cut-off"><span class="sw-chara"><span onclick="javascript:iFavLink(&#39;' + iPlayerResultIdx1arr[i] + '&#39;);" class="icon-on-favorite">★</span>' + iTopRoundNm1arr[i] + '</span></span>';

      if (iResultWin1arr[i] == "LWIN") {
        iHtmlP = iHtmlP + '        <span class="me">' + iLeftUser1arr[i] + '/' + iResult1arr[i] + '<span class="school">' + iLeftTeamNm1arr[i] + '</span></span>';
      }
      else {
        iHtmlP = iHtmlP + '        <span class="me">' + iLeftUser1arr[i] + '<span class="school">' + iLeftTeamNm1arr[i] + '</span></span>';
      }

      iHtmlP = iHtmlP + '        <span class="vs">vs</span>';

      if (iResultWin1arr[i] == "LWIN") {
        iHtmlP = iHtmlP + '        <span class="you">' + iRightUser1arr[i] + '<span class="school">' + iRightTeamNm1arr[i] + '</span></span>';
      }
      else {
        iHtmlP = iHtmlP + '        <span class="you">' + iRightUser1arr[i] + '/' + iResult1arr[i] + '<span class="school">' + iRightTeamNm1arr[i] + '</span></span>';
      }

      iHtmlP = iHtmlP + '      </p>';
      iHtmlP = iHtmlP + '      <!-- <p class="film-info">2016년 춘계 한국중고등학교 유도대회(2016년 3월 25일~28일)</p> -->';
      iHtmlP = iHtmlP + '    </li>';

      $('#sub_table1_1').append(iHtmlP);

    }

  }

  if (TCnt2 > 0) {

    for (var i = 1; i < TCnt2 + 1; i++) {

      if (iTopRoundNm2arr[i] == "2") {
        iTopRoundNm2arr[i] = "결승";
      }
      else if (iTopRoundNm2arr[i] == "4") {
        iTopRoundNm2arr[i] = "준결승";
      }
      else {
        iTopRoundNm2arr[i] = iTopRoundNm2arr[i] + "강";
      }

      iHtmlT = '<li class="clearfix">';
      iHtmlT = iHtmlT + '      <div class="video">';
      iHtmlT = iHtmlT + '        <!-- S: video-title -->';
      iHtmlT = iHtmlT + '        <div class="video-title">';
      iHtmlT = iHtmlT + '          <h3>' + iGameTitleName2arr[i] + '</h3>';
      iHtmlT = iHtmlT + '          <p>대회기간: ' + iGameS2arr[i] + '~' + iGameE2arr[i] + '</p>';
      iHtmlT = iHtmlT + '        </div>';
      iHtmlT = iHtmlT + '        <!-- E: video-title -->';
      iHtmlT = iHtmlT + '        <a href="#" class="play"><iframe width="100%" height="200" src="' + iMediaLink2arr[i] + '?rel=0" frameborder="0" allowfullscreen></iframe></a>';
      iHtmlT = iHtmlT + '      </div>';
      iHtmlT = iHtmlT + '      <p class="video-info group clearfix">';
      iHtmlT = iHtmlT + '        <span class="cut-off"><span class="sw-chara"><span onclick="javascript:iFavLink(&#39;' + iPlayerResultIdx2arr[i] + '&#39;);" class="icon-on-favorite">★</span>' + iTopRoundNm2arr[i] + '</span></span>';

      if (iResultWin2arr[i] == "LWIN") {
        iHtmlT = iHtmlT + '        <span class="me">' + iLeftTeamNm2arr[i] + '/' + iResult2arr[i] + '</span>';
      }
      else {
        iHtmlT = iHtmlT + '        <span class="me">' + iLeftTeamNm2arr[i] + '</span>';
      }

      iHtmlT = iHtmlT + '        <span class="vs">vs</span>';

      if (iResultWin2arr[i] == "LWIN") {
        iHtmlT = iHtmlT + '        <span class="you">' + iRightTeamNm2arr[i] + '</span>';
      }
      else {
        iHtmlT = iHtmlT + '        <span class="you">' + iRightTeamNm2arr[i] + '/' + iResult2arr[i] + '</span>';
      }

      iHtmlT = iHtmlT + '      </p>';
      iHtmlT = iHtmlT + '      <!-- <p class="film-info">2016년 춘계 한국중고등학교 유도대회(2016년 3월 25일~28일)</p> -->';
      iHtmlT = iHtmlT + '    </li>';

      $('#sub_table1_1').append(iHtmlT);

    }

  }

</script>

<% end if %>