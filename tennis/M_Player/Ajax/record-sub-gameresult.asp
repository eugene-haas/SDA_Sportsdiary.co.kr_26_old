<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	
	iPlayerIDX = decode(iPlayerIDX,0)
    
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  'SDate = "2016-03-06"
  'EDate = "2017-03-10"
  'iPlayerIDX = "1403"


  Dim LRsCnt1, iGameTitleName1, iGroupGameGbName1, iTitleResultName1, iLevelName1, iGameDay1
  LRsCnt1 = 0

  iType = "33"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1
        iGameTitleName1 = iGameTitleName1&"^"&LRs("GameTitleName")&""
        iGroupGameGbName1 = iGroupGameGbName1&"^"&LRs("GroupGameGbName")&""
        iTitleResultName1 = iTitleResultName1&"^"&LRs("TitleResultName")&""
        iLevelName1 = iLevelName1&"^"&LRs("LevelName")&""
        iGameYear1 = iGameYear1&"^"&LRs("GameYear")&""

      LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close


  ' 실행 안됌. 31,32 사용에서 33만 사용으로 바꿈
  if LRsCnt1 = -1 then

    Dim LRsCnt2, iGameTitleName2, iGroupGameGbNm2, iGameYear2, iTopRoundNm2
    LRsCnt2 = 0

    iType = "32"

    LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	  'response.Write "LSQL="&LSQL&"<br>"
    'response.End
  
    Set LRs = Dbcon.Execute(LSQL)

    If Not (LRs.Eof Or LRs.Bof) Then
		  Do Until LRs.Eof

          LRsCnt2 = LRsCnt2 + 1

          iGameTitleName2 = iGameTitleName2&"^"&LRs("GameTitleName")&""
          iGroupGameGbNm2 = iGroupGameGbNm2&"^"&LRs("GroupGameGbNm")&""
          iTopRoundNm2 = iTopRoundNm2&"^"&LRs("TopRoundNm")&""
          iGameYear2 = iGameYear2&"^"&LRs("GameYear")&""
          

        LRs.MoveNext
		  Loop
    else
    
	  End If

    LRs.close

  end if


  Dbclose()




%>

<% if LRsCnt1 = 0 then %>

  <dd>조회된 데이터가 없습니다.</dd>

<% Else %>

  <div id="ihtmldiv"></div>

<% End if %>

<% if LRsCnt1 > 0 then %>
<script type="text/javascript">

  var LRsCnt1 = '<%=LRsCnt1%>';
  LRsCnt1 = Number(LRsCnt1);

  if (LRsCnt1 > 0) {

    var iGameTitleName1 = '<%=iGameTitleName1%>';
    var iGroupGameGbName1 = '<%=iGroupGameGbName1%>';
    var iTitleResultName1 = '<%=iTitleResultName1%>';
    var iLevelName1 = '<%=iLevelName1%>';
    var iGameYear1 = '<%=iGameYear1%>';

    var iGameTitleName1arr = iGameTitleName1.split("^");
    var iGroupGameGbName1arr = iGroupGameGbName1.split("^");
    var iTitleResultName1arr = iTitleResultName1.split("^");
    var iLevelName1arr = iLevelName1.split("^");
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

        $('#ihtmldiv').append(ihtml);
      }

    });


    // 상세 내역

    var ihtml1 = "";

    for (var i = 1; i < LRsCnt1 + 1; i++) {

      ihtml1 = '<dd>' + iGameTitleName1arr[i] + '[' + iGroupGameGbName1arr[i] + '] / ' + iTitleResultName1arr[i] + ' / ' + iLevelName1arr[i] + '</dd>';
      $('#iGame_' + iGameYear1arr[i]).append(ihtml1);

    }

  }
  else {

    var LRsCnt2 = '<%=LRsCnt2%>';
    LRsCnt2 = Number(LRsCnt2);

    if (LRsCnt2 > 0) {

      var iGameTitleName2 = '<%=iGameTitleName2%>';
      var iGroupGameGbNm2 = '<%=iGroupGameGbNm2%>';
      var iTopRoundNm2 = '<%=iTopRoundNm2%>';
      var iGameYear2 = '<%=iGameYear2%>';

      var iGameTitleName2arr = iGameTitleName2.split("^");
      var iGroupGameGbNm2arr = iGroupGameGbNm2.split("^");
      var iTopRoundNm2arr = iTopRoundNm2.split("^");
      var iGameYear2arr = iGameYear2.split("^");

      // 년도 distinct : 먼저 년도별로 구역 만듦

      var ihtml2 = "";

      var iGameYear2arrDis = [];

      $.each(iGameYear2arr, function (i, el) {

        if ($.inArray(el, iGameYear2arrDis) === -1) iGameYear2arrDis.push(el);

      });

      $.each(iGameYear2arrDis, function (i, el) {

        if (iGameYear2arrDis[i] != "") {

          ihtml2 = '<div id="iGame_' + iGameYear2arrDis[i] + '">';
          ihtml2 = ihtml2 + '<dt>' + iGameYear2arrDis[i] + '년</dt>';
          ihtml2 = ihtml2 + '</div>';

          $('#ihtmldiv').append(ihtml2);
        }

      });

      // 상세 내역

      var ihtml2_2 = "";

      for (var i = 1; i < LRsCnt2 + 1; i++) {

        if (iTopRoundNm2arr[i] == "2") {
          iTopRoundNm2arr[i] = "결승";
        }
        else if (iTopRoundNm2arr[i] == "4") {
          iTopRoundNm2arr[i] = "준결승";
        }
        else {
          iTopRoundNm2arr[i] = iTopRoundNm2arr[i] + "강";
        }

        ihtml2_2 = '<dd>' + iGameTitleName2arr[i] + '[' + iGroupGameGbNm2arr[i] + '] / ' + iTopRoundNm2arr[i] + '</dd>';
        $('#iGame_' + iGameYear2arr[i]).append(ihtml2_2);

      }


    }

  }

</script>
<% end if %>