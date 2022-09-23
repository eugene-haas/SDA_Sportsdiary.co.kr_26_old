<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->

<%
'Call Response.AddHeader("Access-Control-Allow-Origin", "http://www.sdamall.co.kr")
Call Response.AddHeader("Access-Control-Allow-Origin", "*")
%>



<script language="Javascript" runat="server">
function hasown(obj,  prop){

	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수

	Function getNextStartTime(starttime, ingsec)
			Dim ingmm,starttimearr,tt,mm,nextmm,nt,nm

			ingmm = Ceil_a(ingsec/60)
			starttimearr = Split(starttime,":")
			tt = starttimearr(0)
			mm = starttimearr(1)
			nextmm = CDbl(mm) + CDbl(ingmm)

			If CDbl(nextmm) >= 60  Then
				nt = CDbl(tt) + fix(nextmm/60)
				nm = nextmm Mod 60
				getNextStartTime = addZero(nt) & ":"& addZero(nm)
			Else
				getNextStartTime = addZero(tt) & ":"& addZero(nextmm)
			End if
	End Function

'############################################


	REQ = "{""LIST"":[{""MIDX"":""111985B"",""JOO"":4,""RANE"":1,""ODRNO"":""1"",""GAMERESULT"":""002803""},{""MIDX"":""109966B"",""JOO"":4,""RANE"":2,""ODRNO"":""1"",""GAMERESULT"":""002754""},{""MIDX"":""107630B"",""JOO"":4,""RANE"":3,""ODRNO"":""1"",""GAMERESULT"":""002687""},{""MIDX"":""110903B"",""JOO"":4,""RANE"":4,""ODRNO"":""1"",""GAMERESULT"":""002612""},{""MIDX"":""110869B"",""JOO"":4,""RANE"":5,""ODRNO"":""1"",""GAMERESULT"":""002700""},{""MIDX"":""111284B"",""JOO"":4,""RANE"":6,""ODRNO"":""1"",""GAMERESULT"":""002663""},{""MIDX"":""111495B"",""JOO"":4,""RANE"":7,""ODRNO"":""1"",""GAMERESULT"":""002714""},{""MIDX"":""111492B"",""JOO"":4,""RANE"":8,""ODRNO"":""1"",""GAMERESULT"":""002816""}],""CMD"":530, ""MODE"":""ok""}"


	If InStr(REQ, "CMD") >0 then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if


	%><!-- #include virtual = "/pub/SWAPI/api.SAVERECORDTEST.asp" --><%
	Response.End
%>
