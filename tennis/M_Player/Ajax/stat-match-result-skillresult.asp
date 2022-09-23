<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	iPlayerIDX = fInject(Request("iPlayerIDX"))
	GameTitleIDX = fInject(Request("GameTitleIDX"))
	
	iPlayerIDX = decode(iPlayerIDX,0)

  'iPlayerIDX = "1403"

  'response.Write "SDate="&SDate&"<br>"
  'response.Write "EDate="&EDate&"<br>"
  'response.Write "GameTitleIDX="&GameTitleIDX&"<br>"
  'response.Write "iPlayerIDX="&iPlayerIDX&"<br>"
  'response.End

  'response.Write retext
  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 

  Dim LRsCnt1, iSpecialtyDtlName1, iSpecialtyDtl1
  LRsCnt1 = 0

  iType = "41"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

      LRsCnt1 = LRsCnt1 + 1
      iSpecialtyDtl1 = iSpecialtyDtl1&"^"&LRs("SpecialtyDtl")&""
      iSpecialtyDtlName1 = iSpecialtyDtlName1&"^"&LRs("SpecialtyDtlName")&""

    LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close



  Dim LRsCnt2, iSpecialtyDtlName2, iJumsu2, iSpecialtyDtl2
  LRsCnt2 = 0

  iType = "42"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

      LRsCnt2 = LRsCnt2 + 1
      iSpecialtyDtl2 = iSpecialtyDtl2&"^"&LRs("SpecialtyDtl")&""
      iSpecialtyDtlName2 = iSpecialtyDtlName2&"^"&LRs("SpecialtyDtlName")&""
      iJumsu2 = iJumsu2&"^"&LRs("Jumsu")&""

    LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close


  Dim LRsCnt3, iSpecialtyDtlName3, iJumsu3, iSpecialtyDtl3
  LRsCnt3 = 0

  iType = "43"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Result_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

      LRsCnt3 = LRsCnt3 + 1
      iSpecialtyDtl3 = iSpecialtyDtl3&"^"&LRs("SpecialtyDtl")&""
      iSpecialtyDtlName3 = iSpecialtyDtlName3&"^"&LRs("SpecialtyDtlName")&""
      iJumsu3 = iJumsu3&"^"&LRs("Jumsu")&""

    LRs.MoveNext
		Loop
  else
    
	End If

  LRs.close



  Dbclose()

%>


<% if LRsCnt1 = 0 then %>
  
  <br />
  <span>&nbsp;&nbsp;&nbsp;&nbsp;조회된 데이터가 없습니다.</span>

<% Else %>

  <div id="ihtmldivSkill"></div>

<% End if %>

<% if LRsCnt1 > 0 then %>
<script type="text/javascript">

  var LRsCnt1 = '<%=LRsCnt1%>';
  LRsCnt1 = Number(LRsCnt1);

  if (LRsCnt1 > 0) {

    var iSpecialtyDtl1 = '<%=iSpecialtyDtl1%>';
    var iSpecialtyDtlName1 = '<%=iSpecialtyDtlName1%>';

    var iSpecialtyDtl1arr = iSpecialtyDtl1.split("^");
    var iSpecialtyDtlName1arr = iSpecialtyDtlName1.split("^");


    // Y축 명으로 구조 부터 만듦

    var ihtml1 = '<ul class="chart-title flex">';
    ihtml1 = ihtml1 + '	<li>득점</li>';
    ihtml1 = ihtml1 + '	<li><기술별></li>';
    ihtml1 = ihtml1 + '	<li>실점</li>';
    ihtml1 = ihtml1 + '</ul>';

    for (var i = 1; i < LRsCnt1 + 1; i++) {

      ihtml1 = ihtml1 + '<ul class="skill-list flex">';
      ihtml1 = ihtml1 + '  <li id="iP_' + iSpecialtyDtl1arr[i] + '">';
      ihtml1 = ihtml1 + '    <span>7%</span>';
      ihtml1 = ihtml1 + '    <span class="fill b" style="width: 7%;"></span>';
      ihtml1 = ihtml1 + '    <span class="mask"></span>';
      ihtml1 = ihtml1 + '  </li>';
      ihtml1 = ihtml1 + '  <li>' + iSpecialtyDtlName1arr[i] + '</li>';
      ihtml1 = ihtml1 + '  <li id="iL_' + iSpecialtyDtl1arr[i] + '">';
      ihtml1 = ihtml1 + '    <span>12%</span>';
      ihtml1 = ihtml1 + '    <span class="fill y" style="width: 12%;"></span>';
      ihtml1 = ihtml1 + '    <span class="mask"></span>';
      ihtml1 = ihtml1 + '  </li>';
      ihtml1 = ihtml1 + '</ul>';

      $('#ihtmldivSkill').html(ihtml1);

    }

    // 득점
    var LRsCnt2 = '<%=LRsCnt2%>';
    LRsCnt2 = Number(LRsCnt2);
    
    if (LRsCnt2 > 0) {

      var iSpecialtyDtl2 = '<%=iSpecialtyDtl2%>';
      var iSpecialtyDtlName2 = '<%=iSpecialtyDtlName2%>';
      var iJumsu2 = '<%=iJumsu2%>';

      var iSpecialtyDtl2arr = iSpecialtyDtl2.split("^");
      var iSpecialtyDtlName2arr = iSpecialtyDtlName2.split("^");
      var iJumsu2arr = iJumsu2.split("^");

      var iTotalJumsu2 = 0;

      var ihtml2 = '';

      for (var i = 1; i < LRsCnt2 + 1; i++) {

        iTotalJumsu2 = iTotalJumsu2 + Number(iJumsu2arr[i]);

      }

      var iskillper2 = 0

      for (var i = 1; i < LRsCnt2 + 1; i++) {

        if (iTotalJumsu2 == 0) {
          iskillper2 = 0;
        }
        else {
          iskillper2 = Math.round((Number(iJumsu2arr[i]) / iTotalJumsu2) * 100);
        }

        ihtml2 = '<span>' + iJumsu2arr[i] + '/' + iTotalJumsu2 + '(' + iskillper2 + '%)</span>';
        ihtml2 = ihtml2 + '<span class="fill b" style="width: ' + iskillper2 + '%;"></span>';
        ihtml2 = ihtml2 + '<span class="mask"></span>';

        $('#iP_' + iSpecialtyDtl2arr[i]).html(ihtml2);

      }

    }

    // 실점
    var LRsCnt3 = '<%=LRsCnt3%>';
    LRsCnt3 = Number(LRsCnt3);

    if (LRsCnt3 > 0) {

      var iSpecialtyDtl3 = '<%=iSpecialtyDtl3%>';
      var iSpecialtyDtlName3 = '<%=iSpecialtyDtlName3%>';
      var iJumsu3 = '<%=iJumsu3%>';

      var iSpecialtyDtl3arr = iSpecialtyDtl3.split("^");
      var iSpecialtyDtlName3arr = iSpecialtyDtlName3.split("^");
      var iJumsu3arr = iJumsu3.split("^");

      var iTotalJumsu3 = 0;

      var ihtml3 = '';

      for (var i = 1; i < LRsCnt3 + 1; i++) {

        iTotalJumsu3 = iTotalJumsu3 + Number(iJumsu3arr[i]);

      }

      var iskillper3 = 0

      for (var i = 1; i < LRsCnt3 + 1; i++) {

        if (iTotalJumsu3 == 0) {
          iskillper3 = 0;
        }
        else {
          iskillper3 = Math.round((Number(iJumsu3arr[i]) / iTotalJumsu3) * 100);
        }

        ihtml3 = '<span>' + iJumsu3arr[i] + '/' + iTotalJumsu3 + '(' + iskillper3 + '%)</span>';
        ihtml3 = ihtml3 + '<span class="fill y" style="width: ' + iskillper3 + '%;"></span>';
        ihtml3 = ihtml3 + '<span class="mask"></span>';

        $('#iL_' + iSpecialtyDtl3arr[i]).html(ihtml3);

      }

    }


  }

</script>
<% end if %>