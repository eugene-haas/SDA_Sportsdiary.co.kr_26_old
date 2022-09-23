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

	retext = ""


	'retext = retext&"			  <th>기술명</th>"
	'retext = retext&"				<th>5분대</th>"
	'retext = retext&"				<th>4분대</th>"  
	'retext = retext&"				<th>3분대</th>"  
	'retext = retext&"				<th>2분대</th>" 
	'retext = retext&"				<th>1분대</th>"
  'retext = retext&"				<th>연장</th>"

  Dim LRsCnt1
  LRsCnt1 = 0

  Dim mRname1, mRname1a
  mRname1  = ""

  iType = "1"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Time_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
    retext = retext&"<table class=""time-part"">"
	  retext = retext&"  <thead>"
	  retext = retext&"		  <tr>"
    retext = retext&"			  <th>기술명</th>"

		Do Until LRs.Eof

        LRsCnt1 = LRsCnt1 + 1

        'retext = retext&" <th>""&LRs("CheckTime")&"분대"</th>"
        retext = retext&"				<th>"&Mid(LRs("CheckTime"),2)&"분대</th>"
        mRname1 = mRname1&"^"&LRs("CheckTime")&""
        
        LRs.MoveNext
		Loop
    retext = retext&"				<th>연장</th>"
    retext = retext&"		  </tr>"
	  retext = retext&"  </thead>"
    retext = retext&"  <tbody>"
  else
      
	End If

  LRs.close

  if mRname1 <> "" then
    mRname1 = mRname1&"^99"
    mRname1a = Split(mRname1, "^")
  end if


	'retext = retext&"<tr>"
	'retext = retext&"	  <th>업어치기</th>"
	'retext = retext&"	  <td></td>"
	'retext = retext&"	  <td>9</td>"
	'retext = retext&"	  <td></td>"
	'retext = retext&"	  <td></td>"
	''retext = retext&"	  <td></td>"
	''retext = retext&"	  <td></td>"
  'retext = retext&"</tr>"


  Dim LRsCnt2, Rname1, Rname2, Rname3, Rname4, Rname5
  LRsCnt2 = 0
  Rname1 = ""
  Rname2 = ""
  Rname3 = ""
  Rname4 = ""
  Rname5 = ""

  iType = "21"

  LSQL = "EXEC Stat_Match_Time_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1

        Rname1 = Rname1&"^"&LRs("CheckTime")&""
        Rname2 = Rname2&"^"&LRs("OverTime")&""
        Rname3 = Rname3&"^"&LRs("Jumsu")&""
        Rname4 = Rname4&"^"&LRs("SpecialtyDtl")&""
        Rname5 = Rname5&"^"&LRs("SpecialtyDtlName")&""

        LRs.MoveNext
		Loop
  else
      
	End If

  LRs.close

  'Dim Rname1a, Rname2a, Rname3a, Rname4a, Rname5a
  '
  'if Rname1 <> "" then
  '  Rname1a = Split(Rname1, "^")
  'end if
  '
  'if Rname2 <> "" then
  '  Rname2a = Split(Rname2, "^")
  'end if
  '
  'if Rname3 <> "" then
  '  Rname3a = Split(Rname3, "^")
  'end if
  '
  'if Rname4 <> "" then
  '  Rname4a = Split(Rname4, "^")
  'end if
  '
  'if Rname5 <> "" then
  '  Rname5a = Split(Rname5, "^")
  'end if
  '
  '
  'Dim iPOTCnt
  'iPOTCnt = 0
  '
  'For i = 1 To LRsCnt2
  '
  '  If Rname2a(i) = 1 Then
  '    iPOTCnt = iPOTCnt + Rname3a(i)
  '
  '  End If
  '
  'NEXT


  retext = retext&""
	Response.Write retext

  Dim LRsCnt3
  LRsCnt3 = 0

  iType = "2"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Match_Time_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	'response.Write "LSQL="&LSQL&"<br>"
  'response.End
  
  Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt3 = LRsCnt3 + 1

        'retext = retext&" <th>""&LRs("CheckTime")&"분대"</th>"
        'retext = retext&"				<th>"&LRs("CheckTime")&"분대</th>"
  %>

  <tr>
	  <th><%=LRs("SpecialtyDtlName") %></th>
	  <% For i = 1 To LRsCnt1 + 1 %>
    <td id="<%=mRname1a(i)&"_"&LRs("SpecialtyDtl") %>"></td>
    <% NEXT %>
  </tr>

<%
        
        LRs.MoveNext
		Loop
  else
      response.Write "조회된 데이터가 없습니다."
	End If

  LRs.close

  
  Response.Write  "   </tbody>"
	Response.Write  "</table>"

%>

<% if LRsCnt3 > 0 then %>
<script type="text/javascript">

  var TCnt = Number("<%=LRsCnt1%>");

  var RnameTCnt = Number("<%=LRsCnt2%>");

  var Rname1 = "<%=Rname1%>";
  var Rname2 = "<%=Rname2%>";
  var Rname3 = "<%=Rname3%>";
  var Rname4 = "<%=Rname4%>";
  var Rname5 = "<%=Rname5%>";

  //alert("TCnt:" + TCnt + "\r\n" + "RnameTCnt:" + RnameTCnt + "\r\n" +"Rname1:" + Rname1 + "\r\n");

  var Rname1arr = Rname1.split("^");
  var Rname2arr = Rname2.split("^");
  var Rname3arr = Rname3.split("^");
  var Rname4arr = Rname4.split("^");
  var Rname5arr = Rname5.split("^");

  //alert(Rname5arr[5]);
  var iIDX = "";
  var iPIDX = "";
  var iPIDXValue = "";
  var iPIDXSum = 0;

  for (var i = 1; i < RnameTCnt + 1; i++) {

    if (Rname2arr[i] == "0") {
      iIDX = Rname1arr[i] + "_" + Rname4arr[i];
      $("#" + iIDX).text(Rname3arr[i]);
    }
    else if (Rname2arr[i] == "1") {

      iPIDX = "99_" + Rname4arr[i];
      iPIDXValue = $("#" + iPIDX).text();
      if (iPIDXValue == "") {
        $("#" + iPIDX).text(Rname3arr[i]);
      }
      else {
        $("#" + iPIDX).text(Number($("#" + iPIDX).text()) + Number(Rname3arr[i]));
      }

    }

  }


</script>
<% end if %>