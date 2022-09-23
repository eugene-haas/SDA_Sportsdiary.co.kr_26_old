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

  
  'SDate = "2016-01-01"
  'EDate = "2016-12-31"
  'GameTitleIDX = "00"
  'iPlayerIDX = "1403"

  'response.Write "SDate="&SDate&"<br>"
  'response.Write "EDate="&EDate&"<br>"
  'response.Write "GameTitleIDX="&GameTitleIDX&"<br>"
  'response.Write "iPlayerIDX="&iPlayerIDX&"<br>"
  'response.End

  'response.Write retext



  Dim LRsCnt2 , Rname1, Rname2, Rname3, Rname4, Rname5, Rname6, Rname7, Rname8, Rname9, Rname10, Rname11, Rname12
  LRsCnt2 = 0
  Rname1 = ""
  Rname2 = ""
  Rname3 = ""
  Rname4 = ""
  Rname5 = ""
  Rname6 = ""
  Rname7 = ""
  Rname8 = ""
  Rname9 = ""
  Rname10 = ""
  Rname11 = ""
  Rname12 = ""

  iType = "21"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Win_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1

        Rname1 = Rname1&"^"&LRs("GameScoreIDX")&""
        Rname2 = Rname2&"^"&LRs("GameTitleIDX")&""
        Rname3 = Rname3&"^"&LRs("GameTitleName")&""
        Rname4 = Rname4&"^"&LRs("GroupGameGb")&""
        Rname5 = Rname5&"^"&LRs("GroupGameGbName")&""
        Rname6 = Rname6&"^"&LRs("TeamNm")&""
        Rname7 = Rname7&"^"&LRs("Sex")&""
        Rname8 = Rname8&"^"&LRs("TitleResultName")&""
        Rname9 = Rname9&"^"&LRs("GameS")&""
        Rname10 = Rname10&"^"&LRs("GameE")&""
        Rname11 = Rname11&"^"&LRs("LevelName")&""
        Rname12 = Rname12&"^"&LRs("TeamGbName")&""

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close


  Dim LRsCnt1 , iGameS , iGameE, iGameSarr, iGameEarr, iGameST, iGameET
  LRsCnt1 = 0

  iType = "2"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Win_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        iGameS = Mid(LRs("GameS"), 6, len(LRs("GameS")) - 5)
        iGameE = Mid(LRs("GameE"), 6, len(LRs("GameE")) - 5)

        iGameSarr = Split(iGameS, "-")
        iGameEarr = Split(iGameE, "-")

        iGameST = iGameSarr(0)&"/"&iGameSarr(1)
        iGameET = iGameEarr(0)&"/"&iGameEarr(1)
  %>


<li>
  <h4 class="clearfix"><span class="match-day"><%=iGameST %>~<%=iGameET %></span><span class="match-title"><%=LRs("GameTitleName") %></span></h4>

  <div id="GIDX_<%=LRs("GameTitleIDX") %>">
  <!--<a href="#" class="clearfix" data-target="#show-score" data-toggle="modal">
    <span class="result">
      <span class="img-deco golden"></span><span>금메달</span></span>
    <span class="result-list">
      <span>개인전</span>
      <span>고등부</span>
      <span>남자</span>
      <span>-66kg</span>
      <span>철원고등학교</span>
    </span>
  </a>-->
  </div>

</li>


<%

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close

  Dbclose()

%>


<script type="text/javascript">

  var TCnt1 = Number("<%=LRsCnt1%>");
  var TCnt2 = Number("<%=LRsCnt2%>");

  var Rname1 = "<%=Rname1%>";
  var Rname2 = "<%=Rname2%>";
  var Rname3 = "<%=Rname3%>";
  var Rname4 = "<%=Rname4%>";
  var Rname5 = "<%=Rname5%>";
  var Rname6 = "<%=Rname6%>";
  var Rname7 = "<%=Rname7%>";
  var Rname8 = "<%=Rname8%>";
  var Rname9 = "<%=Rname9%>";
  var Rname10 = "<%=Rname10%>";
  var Rname11 = "<%=Rname11%>";
  var Rname12 = "<%=Rname12%>";


  //alert("TCnt:" + TCnt + "\r\n" + "Rname1:" + Rname1 + "\r\n" + "Rname7:" + Rname7 + "\r\n");

  var Rname1arr = Rname1.split("^");
  var Rname2arr = Rname2.split("^");
  var Rname3arr = Rname3.split("^");
  var Rname4arr = Rname4.split("^");
  var Rname5arr = Rname5.split("^");
  var Rname6arr = Rname6.split("^");
  var Rname7arr = Rname7.split("^");
  var Rname8arr = Rname8.split("^");
  var Rname9arr = Rname9.split("^");
  var Rname10arr = Rname10.split("^");
  var Rname11arr = Rname11.split("^");
  var Rname12arr = Rname12.split("^");

  var iHtml1 = "";
  var iTRNType = "";
  var iTRNTypeLink = "";

  for (var i = 1; i < TCnt2 + 1; i++) {

    iTRNType = Rname8arr[i];

    if (iTRNType == "금메달") {
      iTRNTypeLink = "golden";
    }
    else if (iTRNType == "은메달") {
      iTRNTypeLink = "silver";
    }
    else if (iTRNType == "동메달") {
      iTRNTypeLink = "bronze";
    }
    else {
      iTRNTypeLink = "";
    }


    //iHtml1 = '<a href="javascript:iMovieLink(' + Rname1arr[i] + ');" class="clearfix" data-target="#show-score" data-toggle="modal">';
    if (Rname5arr[i] == "개인전") {
      iHtml1 = '<a href="#" onclick="javascript:iMovieLink(&#39;' + Rname1arr[i] + '&#39;,&#39;' + Rname4arr[i] + '&#39;);" class="clearfix" data-target="#show-score" data-toggle="modal">';
    }
    else {
      iHtml1 = '<a href="#" onclick="javascript:iMovieLink(&#39;' + Rname1arr[i] + '&#39;,&#39;' + Rname4arr[i] + '&#39;);" data-toggle="modal" data-target=".groups-res">';
    }

    iHtml1 = iHtml1 + '<span class="result">';
    iHtml1 = iHtml1 + '<span class="img-deco ' + iTRNTypeLink + '"></span><span>' + iTRNType + '</span></span>';
    iHtml1 = iHtml1 + '<span class="result-list">';
    iHtml1 = iHtml1 + '<span>' + Rname5arr[i] + '</span>';
    iHtml1 = iHtml1 + '<span>' + Rname12arr[i] + '</span>';
    //iHtml1 = iHtml1 + '<span>' + Rname7arr[i] + '</span>';
    iHtml1 = iHtml1 + '<span>' + Rname11arr[i] + '</span>';
    iHtml1 = iHtml1 + '<span>' + Rname6arr[i] + '</span>';
    iHtml1 = iHtml1 + '</span>';
    iHtml1 = iHtml1 + '</a>';

    $("#GIDX_" + Rname2arr[i]).append(iHtml1);

  }


</script>