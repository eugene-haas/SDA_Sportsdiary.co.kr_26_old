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


  Dim LRsCnt1
  LRsCnt1 = 0

  iType = "2"
  'iSportsGb = "judo"

  LSQL = "EXEC Analysis_Match_Skill_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = ""

  retext = retext&"<table class=""skill-part"">"
	retext = retext&"  <thead>"
	retext = retext&"		  <tr>"
	retext = retext&"				  <th colspan=""3"" class=""get-point"">득점</th>"
	retext = retext&"				  <th rowspan=""2"">기술명</th>"
	retext = retext&"				  <th colspan=""3"" class=""lost-point"">실점</th>"
	retext = retext&"		  </tr>"
	retext = retext&"		  <tr>"
	retext = retext&"				  <td>좌측</td>"
	retext = retext&"				  <td>우측</td>"
	retext = retext&"				  <td class=""gain-total"">합계</td>"
	retext = retext&"				  <td class=""lost-total"">합계</td>"
	retext = retext&"				  <td>좌측</td>"
	retext = retext&"				  <td>우측</td>"
	retext = retext&"		  </tr>"
	retext = retext&"  </thead>"
  retext = retext&"  <tbody>"

	'retext = retext&"    <tr>"
	'retext = retext&"    	<td class=""big-point"">21</td>"
	'retext = retext&"    	<td class=""big-point"">19</td>"
	'retext = retext&"    	<td class=""gain-total ext"">40</td>"
	'retext = retext&"    	<th>양소매 업어치기</th>"
	'retext = retext&"    	<td class=""lost-total ext"">3</td>"
	'retext = retext&"    	<td>3</td>"
	'retext = retext&"    	<td>3</td>"
	'retext = retext&"    </tr>"

  retext = retext&""

	Response.Write retext

		Do Until LRs.Eof
        LRsCnt1 = LRsCnt1 + 1
%>
          <tr>
	          <td id="LPPoint_<%=LRsCnt1%>"></td>
	          <td id="RPPoint_<%=LRsCnt1%>"></td>
	          <td class="gain-total" id="TPPoint_<%=LRsCnt1%>"></td>
	          <th id="SName_<%=LRsCnt1%>"><%=LRs("SpecialtyDtlName") %></th>
	          <td class="lost-total" id="TMPoint_<%=LRsCnt1%>"></td>
	          <td id="LMPoint_<%=LRsCnt1%>"></td>
	          <td id="RMPoint_<%=LRsCnt1%>"></td>
	        </tr>
<%
      LRs.MoveNext
		Loop
  else
  %>
<table class="skill-part">
  <thead>
  </thead>
  <tbody>
    조회된 데이터가 없습니다.
  </tbody>
</table>
<%
	End If

  LRs.close


  Dim LRsCnt2
  LRsCnt2 = 0
  Rname1 = ""
  Rname2 = ""
  Rname3 = ""

  iType = "21"

  LSQL = "EXEC Analysis_Match_Skill_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1

        Rname1 = Rname1&"^"&LRs("PubName")&""
        Rname2 = Rname2&"^"&LRs("SpecialtyDtlName")&""
        Rname3 = Rname3&"^"&LRs("Jumsu")&""

        LRs.MoveNext
		Loop
  else
      
	End If

  LRs.close


  Dim mLRsCnt2
  mLRsCnt2 = 0
  mRname1 = ""
  mRname2 = ""
  mRname3 = ""

  iType = "22"

  LSQL = "EXEC Analysis_Match_Skill_Search '" & iType & "','" & iSportsGb & "','" & iPlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "'"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        mLRsCnt2 = mLRsCnt2 + 1

        mRname1 = mRname1&"^"&LRs("PubName")&""
        mRname2 = mRname2&"^"&LRs("SpecialtyDtlName")&""
        mRname3 = mRname3&"^"&LRs("Jumsu")&""

        LRs.MoveNext
		Loop

    Response.Write  "   </tbody>"
	  Response.Write  "</table>"

  else
      
	End If

  LRs.close

  Dbclose()


	
%>

<% if LRsCnt1 > 0 then %>

<script type="text/javascript">

  var TCnt = Number("<%=LRsCnt1%>");

  var RnameTCnt = Number("<%=LRsCnt2%>");

  var Rname1 = "<%=Rname1%>";
  var Rname2 = "<%=Rname2%>";
  var Rname3 = "<%=Rname3%>";

  var Rname1arr = Rname1.split("^");
  var Rname2arr = Rname2.split("^");
  var Rname3arr = Rname3.split("^");

  var Rname1arrTitle = "";
  var Rname2arrTitle = "";
  var Rname3arrTitle = "";
  
  var SNameTitleID = "";
  var SNameTitle = "";

  var itp = 0;

  for (var i = 1; i < TCnt + 1; i++) {

    SNameTitleID = "SName_" + i;
    SNameTitle = $('#'+SNameTitleID+'').text();

    //alert(SNameTitle);

    for (var j = 0; j < RnameTCnt; j++) {
      Rname1arrTitle = Rname1arr[j + 1];
      Rname2arrTitle = Rname2arr[j + 1];
      Rname3arrTitle = Rname3arr[j + 1];
      if (Rname2arrTitle == SNameTitle) {
        if (Rname1arrTitle == "왼쪽") {
          $("#LPPoint_" + i).text(Rname3arrTitle);
        }
        else if (Rname1arrTitle == "오른쪽") {
          $("#RPPoint_" + i).text(Rname3arrTitle);
        }
        //alert("SNameTitle:" + SNameTitle + "\r\n\r\n" + "Rname2arrTitle:" + Rname2arrTitle + "\r\n\r\n" + "Rname1arrTitle:" + Rname1arrTitle + "\r\n\r\n" + "Rname3arrTitle:" + Rname3arrTitle);
      }
    }

    //document.getElementById("TPPoint_" + i).innerHTML = Number(document.getElementById("LPPoint_" + i).childNodes[0].nodeValue) + Number(document.getElementById("RPPoint_" + i).childNodes[0].nodeValue);
    //document.getElementById("TMPoint_" + i).innerHTML = Number(document.getElementById("LMPoint_" + i).childNodes[0].nodeValue) + Number(document.getElementById("RMPoint_" + i).childNodes[0].nodeValue);
    //$("#TPPoint_" + i).text(Number($("#LPPoint_" + i).text()) + Number($("#RPPoint_" + i).text()));

    itp = Number($("#LPPoint_" + i).text()) + Number($("#RPPoint_" + i).text());

    if (itp == 0) {

    }
    else {
      $("#TPPoint_" + i).text(itp);
    }

    //$("#TMPoint_" + i).text(Number($("#LMPoint_" + i).text()) + Number($("#RMPoint_" + i).text()));
  }


  //alert($('#LPPoint_1').text());
  //alert("RnameTCnt: " + RnameTCnt + "\r\n\r\n" + "Rname1: " + Rname1 + "\r\n\r\n" + "Rname2: " + Rname2 + "\r\n\r\n" + "Rname3: " + Rname3);
  //alert(Rname2arr[5]);


  var mRnameTCnt = Number("<%=mLRsCnt2%>");

  var mRname1 = "<%=mRname1%>";
  var mRname2 = "<%=mRname2%>";
  var mRname3 = "<%=mRname3%>";

  var mRname1arr = mRname1.split("^");
  var mRname2arr = mRname2.split("^");
  var mRname3arr = mRname3.split("^");

  var mRname1arrTitle = "";
  var mRname2arrTitle = "";
  var mRname3arrTitle = "";

  var mSNameTitleID = "";
  var mSNameTitle = "";

  var imp = 0;

  for (var i = 1; i < TCnt + 1; i++) {

    mSNameTitleID = "SName_" + i;
    mSNameTitle = $('#' + mSNameTitleID + '').text();

    //alert(SNameTitle);

    for (var j = 0; j < mRnameTCnt; j++) {
      mRname1arrTitle = mRname1arr[j + 1];
      mRname2arrTitle = mRname2arr[j + 1];
      mRname3arrTitle = mRname3arr[j + 1];
      if (mRname2arrTitle == mSNameTitle) {
        if (mRname1arrTitle == "왼쪽") {
          $("#LMPoint_" + i).text(mRname3arrTitle);
        }
        else if (Rname1arrTitle == "오른쪽") {
          $("#RMPoint_" + i).text(mRname3arrTitle);
        }
        //alert("SNameTitle:" + SNameTitle + "\r\n\r\n" + "Rname2arrTitle:" + Rname2arrTitle + "\r\n\r\n" + "Rname1arrTitle:" + Rname1arrTitle + "\r\n\r\n" + "Rname3arrTitle:" + Rname3arrTitle);
      }
    }

    //document.getElementById("TPPoint_" + i).innerHTML = Number(document.getElementById("LPPoint_" + i).childNodes[0].nodeValue) + Number(document.getElementById("RPPoint_" + i).childNodes[0].nodeValue);
    //document.getElementById("TMPoint_" + i).innerHTML = Number(document.getElementById("LMPoint_" + i).childNodes[0].nodeValue) + Number(document.getElementById("RMPoint_" + i).childNodes[0].nodeValue);
    //$("#TPPoint_" + i).text(Number($("#LPPoint_" + i).text()) + Number($("#RPPoint_" + i).text()));
    //$("#TMPoint_" + i).text(Number($("#LMPoint_" + i).text()) + Number($("#RMPoint_" + i).text()));

    imp = Number($("#LMPoint_" + i).text()) + Number($("#RMPoint_" + i).text());

    if (imp == 0) {

    }
    else {
      $("#TMPoint_" + i).text(imp);
    }

  }


</script>

<% end if %>