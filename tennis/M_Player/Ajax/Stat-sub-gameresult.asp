<!--#include file="../Library/ajax_config_26.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	iGameTitleIDX = fInject(Request("iGameTitleIDX"))
	
	iPlayerIDX = decode(iPlayerIDX,0)
    
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  'SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = fInject(Request("SportsGb"))
  iEnterType = EnterType
 '2017-06-26 추가 

  'SDate = "2016-03-06"
  'EDate = "2017-03-10"
  'iPlayerIDX = "1403"


  Dim LRsCnt1, iGameTitleName1, iGroupGameGbName1, iTitleResultName1, iGameYear1
  LRsCnt1 = 0

  iType = "33"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & iGameTitleIDX & "','','','','',''"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        iGameTitleName1 = iGameTitleName1&"^"&LRs("key1name")&""
        iGroupGameGbName1 = iGroupGameGbName1&"^"&LRs("key3name")&""
        iTitleResultName1 = iTitleResultName1&"^"&LRs("ranking")&""
        iGameYear1 = iGameYear1&"^"&LRs("gameyear")&""

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close


  Dbclose()


%>

<% if LRsCnt1 = 0 then %>

<div id="ihtmldiv">
	<!-- S: 최근 경기이력 best-win -->
	<section class="record best-win">
		<h3>최근 입상이력 <!--<span class="record-info">＊입상이력은 개인전만 반영됩니다.</span>--></h3>
		<dl class="clearfix" id="iGameResult">
			<dd>조회된 데이터가 없습니다.</dd>
		</dl>
	</section>
	<!-- E: 최근 경기이력 best-win -->
</div>

<% Else %>

<div id="ihtmldiv">
	<!-- S: 최근 경기이력 best-win -->
	<section class="record best-win">
		<h3>최근 입상이력 <!--<span class="record-info">＊입상이력은 개인전만 반영됩니다.</span>--></h3>
		<dl class="clearfix" id="iGameResult">
			
		</dl>
	</section>
	<!-- E: 최근 경기이력 best-win -->
</div>

<% End if %>


<% if LRsCnt1 > 0 then %>
<script type="text/javascript">

  var LRsCnt1 = '<%=LRsCnt1%>';
  LRsCnt1 = Number(LRsCnt1);

  var iGameTitleName1 = '<%=iGameTitleName1%>';
  var iGroupGameGbName1 = '<%=iGroupGameGbName1%>';
  var iTitleResultName1 = '<%=iTitleResultName1%>';
  var iGameYear1 = '<%=iGameYear1%>';

  var iGameTitleName1arr = iGameTitleName1.split("^");
  var iGroupGameGbName1arr = iGroupGameGbName1.split("^");
  var iTitleResultName1arr = iTitleResultName1.split("^");
  var iGameYear1arr = iGameYear1.split("^");


  // 년도 distinct : 먼저 년도별로 구역 만듦

  var ihtml = "";

  var iGameYear1arrDis = [];

  $.each(iGameYear1arr, function (i, el) {

    if ($.inArray(el, iGameYear1arrDis) === -1) iGameYear1arrDis.push(el);

  });

  $.each(iGameYear1arrDis, function (i, el) {

    if (iGameYear1arrDis[i] != "") {

      ihtml = '<div id="iGame_' + iGameYear1arrDis[i] + '">';
      ihtml = ihtml + '<dt>' + iGameYear1arrDis[i] + '년</dt>';
      ihtml = ihtml + '</div>';

      $('#iGameResult').append(ihtml);
    }

  });


  // 상세 내역

  var ihtml1 = "";

  for (var i = 1; i < LRsCnt1 + 1; i++) {

  	if (iTitleResultName1arr[i] == "1") {
  		iTitleResultName1arr[i] = "1위";
  	}
  	else if (iTitleResultName1arr[i] == "2") {
  		iTitleResultName1arr[i] = "2위";
  	}
  	else if (iTitleResultName1arr[i] == "3") {
  		iTitleResultName1arr[i] = "3위";
  	}
  	else if (iTitleResultName1arr[i] == "4") {
  		iTitleResultName1arr[i] = "4위";
  	}
  	else {
  		iTitleResultName1arr[i] = iTitleResultName1arr[i] + "강";
  	}

    ihtml1 = '<dd>' + iGameTitleName1arr[i] + '  /  ' + iGroupGameGbName1arr[i] + '  /  ' + iTitleResultName1arr[i] + '</dd>';
    $('#iGame_' + iGameYear1arr[i]).append(ihtml1);

  }

</script>
<% end if %>
