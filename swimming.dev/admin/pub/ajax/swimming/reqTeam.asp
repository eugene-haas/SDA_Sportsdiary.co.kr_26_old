<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
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
'############################################

	If request("test") = "t" Then
		REQ ="{""CMD"":301,""PARR"":[""E"",""SW70011"",""어쩌다"",""대한민국"",""서울"",""2"",""3"",""2019/12/19"",""2019/12/11"",""짱님"",""지도자님"",""10544"",""경기 고양시 덕양구 가양대로 110 (덕은동) 여기는어디"",""07011111111"",""2019/12/11""]}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if

	CMD_GAMEINPUT = 301
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 303
	CMD_GAMEINPUTDEL = 304
	CMD_COPYTEAM = 400 '체육회 정보가져오기



	Select Case CDbl(CMD)

	Case CMD_COPYTEAM
		%><!-- #include virtual = "/pub/api/swimmingAdmin/team/api.copyTeam.asp" --><%
	Response.end

	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/team/api.teamInput.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/team/api.teamInputedit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/swimmingAdmin/team/api.teamInputeditok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/swimmingAdmin/team/api.teamInputDel.asp" --><%
	Response.end
	
	
	
	Response.End
	End Select
%>
