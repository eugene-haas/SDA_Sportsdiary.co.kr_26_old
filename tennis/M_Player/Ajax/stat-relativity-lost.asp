<!--#include file="../Library/ajax_config.asp"-->
<%
	Check_Login()
	
	SDate = fInject(Request("SDate"))
	EDate = fInject(Request("EDate"))
	GameTitleIDX = ""
	PlayerIDX = fInject(Request("PlayerIDX"))
	Sub_Type = fInject(Request("Sub_Type"))
	
	PlayerIDX = decode(PlayerIDX,0)

  'response.Write "SDate="&SDate&"<br>"
  'response.Write "EDate="&EDate&"<br>"
  'response.Write "GameTitleIDX="&GameTitleIDX&"<br>"
  'response.Write "PlayerIDX="&PlayerIDX&"<br>"
  'response.Write "Sub_Type="&Sub_Type&"<br>"
  'response.End

  
 '2017-06-26 추가 (아마추어 / 종목 구분 추가 )
  SportsGb 	=  Request.Cookies("SportsGb")
  EnterType =  Request.Cookies("EnterType") 

  iSportsGb = SportsGb
  iEnterType = EnterType
 '2017-06-26 추가 


  Dim LRsCnt1, iLpoint, iRpoint, iTpoint, jSpecialtyDtl
  LRsCnt1 = 0
  jSpecialtyDtl = ""

  iType = "14"
  'iSportsGb = "judo"

  LSQL = "EXEC Stat_Relativity_Search '" & iType & "','" & iSportsGb & "','" & PlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','" & Sub_Type & "'"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then

    retext = "<h3>"&Sub_Type&"</h3>"
	  retext = retext&"<table class=""skill-part"">"
	  retext = retext&"	<thead>"
	  retext = retext&"		<tr>"
	  retext = retext&"			<th rowspan=""2"">기술명</th>"
	  retext = retext&"			<th colspan=""3"" class=""get-point"">득점</th>"
	  retext = retext&"		</tr>"
	  retext = retext&"		<tr>"
	  retext = retext&"			<td>좌측</td>"
	  retext = retext&"			<td>우측</td>"
	  retext = retext&"			<td class=""gain-total"">합계</td>"
	  retext = retext&"		</tr>"
	  retext = retext&"	</thead>"

	  retext = retext&"	<tbody>"

    'retext = retext&"		<tr>"
	  'retext = retext&"			<th>한팔 업어치기</th>"
	  'retext = retext&"			<td class=""big-lost"">57</td>"
	  'retext = retext&"			<td class=""big-lost"">30</td>"
	  'retext = retext&"			<td class=""big-lost"">27</td>"
	  'retext = retext&"		</tr>"
	  'retext = retext&"		<tr>"


	  Response.Write retext

		Do Until LRs.Eof
        LRsCnt1 = LRsCnt1 + 1
        iLpoint = LRs("SpecialtyDtl")&"_L"
        iRpoint = LRs("SpecialtyDtl")&"_R"
        iTpoint = LRs("SpecialtyDtl")&"_T"
        jSpecialtyDtl = jSpecialtyDtl&"^"&LRs("SpecialtyDtl")&""
%>

	<tr>
		<th><%=LRs("SpecialtyDtlName") %></th>
		<td id="<%=iLpoint %>"></td>
		<td id="<%=iRpoint %>"></td>
		<td id="<%=iTpoint %>"></td>
	</tr>

<%
      LRs.MoveNext
		Loop
  
    Response.Write  "   </tbody>"
	  Response.Write  "</table>"  

  else

	end if

  LRs.close


  Dim LRsCnt2
  LRsCnt2 = 0
  iJumsu = ""
  iPubName = ""
  iSpecialtyDtl = ""


  iType = "15"

  LSQL = "EXEC Stat_Relativity_Search '" & iType & "','" & iSportsGb & "','" & PlayerIDX & "','" & SDate & "','" & EDate & "','" & GameTitleIDX & "','" & Sub_Type & "'"
	Set LRs = Dbcon.Execute(LSQL)

  If Not (LRs.Eof Or LRs.Bof) Then
		Do Until LRs.Eof

        LRsCnt2 = LRsCnt2 + 1

        iJumsu = iJumsu&"^"&LRs("Jumsu")&""
        iPubName = iPubName&"^"&LRs("PubName")&""
        iSpecialtyDtl = iSpecialtyDtl&"^"&LRs("SpecialtyDtl")&""

        LRs.MoveNext
		Loop
  else
      
	End If

  LRs.close

  Dbclose()

%>

<script type="text/javascript">

  // 점수 밀어 넣기
  var TCnt2 = Number("<%=LRsCnt2%>");

  var iJumsu = "<%=iJumsu%>";
  var iPubName = "<%=iPubName%>";
  var iSpecialtyDtl = "<%=iSpecialtyDtl%>";

  var iJumsuarr = iJumsu.split("^");
  var iPubNamearr = iPubName.split("^");
  var iSpecialtyDtlarr = iSpecialtyDtl.split("^");

  var tdid = "";

  for (var i = 1; i < TCnt2 + 1; i++) {

    if (iPubNamearr[i] == "왼쪽") {
      iPubNamearr[i] = "L";
    }
    else {
      iPubNamearr[i] = "R";
    }

    tdid = iSpecialtyDtlarr[i] + "_" + iPubNamearr[i];

    $('#' + tdid).text(iJumsuarr[i]);

  }

  // 합산
  var TCnt1 = Number("<%=LRsCnt1%>");

  var jSpecialtyDtl = "<%=jSpecialtyDtl%>";

  var jSpecialtyDtlarr = jSpecialtyDtl.split("^");

  var tdidTotal = "";
  var tdidLp = "";
  var tdidRp = "";

  for (var i = 1; i < TCnt1 + 1; i++) {

    tdidLp = jSpecialtyDtlarr[i] + "_L";
    tdidRp = jSpecialtyDtlarr[i] + "_R";
    tdidTotal = jSpecialtyDtlarr[i] + "_T";
    $('#' + tdidTotal).text(Number($('#' + tdidLp).text()) + Number($('#' + tdidRp).text()));

  }


</script>
