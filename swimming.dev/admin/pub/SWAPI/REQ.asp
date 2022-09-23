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

	If request("test") = "t" Then
		'REQ = "{""LIST"":[{""MIDX"":""89758A"",""SECTIONNO"":""50"",""SECTIONRESULT"":""001234"",""GAMERESULT"":""004321""},{""MIDX"":""89759A"",""SECTIONNO"":""50"",""SECTIONRESULT"":""001234"",""GAMERESULT"":""004321""},{""MIDX"":""89760A"",""SECTIONNO"":""50"",""SECTIONRESULT"":""001234"",""GAMERESULT"":""004321""},{""MIDX"":""89761A"",""SECTIONNO"":""50"",""SECTIONRESULT"":""001234"",""GAMERESULT"":""004321""},{""MIDX"":""89762A"",""SECTIONNO"":""50"",""SECTIONRESULT"":""001234"",""GAMERESULT"":""004321""},{""MIDX"":""89763A"",""SECTIONNO"":""50"",""SECTIONRESULT"":""001234"",""GAMERESULT"":""004321""}],""CMD"":540,""MODE"":""ok""}"

		'REQ = "{""LIST"":[{""MIDX"":""89758A"",""SECTIONNO"":""100"",""SECTIONRESULT"":""002345"",""GAMERESULT"":""004321""},{""MIDX"":""89759A"",""SECTIONNO"":""100"",""SECTIONRESULT"":""002345"",""GAMERESULT"":""004321""},{""MIDX"":""89760A"",""SECTIONNO"":""100"",""SECTIONRESULT"":""002345"",""GAMERESULT"":""004321""},{""MIDX"":""89761A"",""SECTIONNO"":""100"",""SECTIONRESULT"":""002345"",""GAMERESULT"":""004321""},{""MIDX"":""89762A"",""SECTIONNO"":""100"",""SECTIONRESULT"":""002345"",""GAMERESULT"":""004321""},{""MIDX"":""89763A"",""SECTIONNO"":""100"",""SECTIONRESULT"":""002345"",""GAMERESULT"":""004321""}],""CMD"":540,""MODE"":""ok""}"


		'REQ = "{""LIST"":[{""MIDX"":""89758A"",""SECTIONNO"":""150"",""SECTIONRESULT"":""003257"",""GAMERESULT"":""004321""},{""MIDX"":""89759A"",""SECTIONNO"":""150"",""SECTIONRESULT"":""003257"",""GAMERESULT"":""004321""},{""MIDX"":""89760A"",""SECTIONNO"":""150"",""SECTIONRESULT"":""003257"",""GAMERESULT"":""004321""},{""MIDX"":""89761A"",""SECTIONNO"":""150"",""SECTIONRESULT"":""003257"",""GAMERESULT"":""004321""},{""MIDX"":""89762A"",""SECTIONNO"":""150"",""SECTIONRESULT"":""003257"",""GAMERESULT"":""004321""},{""MIDX"":""89763A"",""SECTIONNO"":""150"",""SECTIONRESULT"":""003257"",""GAMERESULT"":""004321""}],""CMD"":540,""MODE"":""ok""}"

		REQ = "{""LIST"":[{""MIDX"":""89758A"",""SECTIONNO"":""200"",""SECTIONRESULT"":""004723"",""GAMERESULT"":""004321""},{""MIDX"":""89759A"",""SECTIONNO"":""200"",""SECTIONRESULT"":""004723"",""GAMERESULT"":""004321""},{""MIDX"":""89760A"",""SECTIONNO"":""200"",""SECTIONRESULT"":""004723"",""GAMERESULT"":""004321""},{""MIDX"":""89761A"",""SECTIONNO"":""200"",""SECTIONRESULT"":""004723"",""GAMERESULT"":""004321""},{""MIDX"":""89762A"",""SECTIONNO"":""200"",""SECTIONRESULT"":""004723"",""GAMERESULT"":""004321""},{""MIDX"":""89763A"",""SECTIONNO"":""200"",""SECTIONRESULT"":""004723"",""GAMERESULT"":""004321""}],""CMD"":540,""MODE"":""ok""}"

	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		response.write "{""CMD"": ""530"",""result"":99}"
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if


	CMD_GETGAMENOLIST = 510 '대회번호_조수
	CMD_GAMEMEMBER = 520	'참가자리스트
	CMD_SAVERECORD = 530	'기록 저장하기
	CMD_SAVESECTIONRECORD = 540	'구간기록 저장
	Select Case CDbl(CMD)

	Case CMD_GAMEMEMBER
		%><!-- #include virtual = "/pub/SWAPI/api.GAMEMEMBER.asp" --><%
	Response.End

	Case CMD_SAVERECORD
		%><!-- #include virtual = "/pub/SWAPI/api.SAVERECORD.asp" --><%
	Response.End

	Case CMD_SAVESECTIONRECORD
		%><!-- #include virtual = "/pub/SWAPI/api.SAVESECTIONRECORD.asp" --><%
	Response.End

	Case CMD_GETGAMENOLIST
		%><!-- #include virtual = "/pub/SWAPI/api.GAMENOLIST.asp" --><%
	Response.End

	End Select
%>
