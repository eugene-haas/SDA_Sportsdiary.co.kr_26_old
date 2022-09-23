<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
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
		REQ ="{""CMD"":500,""IDX"":8751}"
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
	CMD_FINDLEADER = 401 '리더찾기
    CMD_SETYN  = 500 '신청처리
	CMD_GETWIN = 40000 '선수창
	CMD_RESETTEAM = 600 '팀정보 초기화

	Select Case CDbl(CMD)
	Case CMD_RESETTEAM
		%><!-- #include virtual = "/pub/api/RidingAdmin/team/api.resetteam.asp" --><%
	Response.End
	
	Case CMD_GETWIN
		%><!-- #include virtual = "/pub/api/RidingAdmin/team/api.getWin.asp" --><%
	Response.end

	Case CMD_SETYN
		%><!-- #include virtual = "/pub/api/RidingAdmin/team/api.setyn.asp" --><%
	Response.end


	Case CMD_FINDLEADER
		%><!-- #include virtual = "/pub/api/RidingAdmin/team/api.FindLeader.asp" --><%
	Response.end

	Case CMD_COPYTEAM
		%><!-- #include virtual = "/pub/api/RidingAdmin/team/api.copyTeam.asp" --><%
	Response.end

	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/RidingAdmin/team/api.teamInput.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/team/api.teamInputedit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/team/api.teamInputeditok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/team/api.teamInputDel.asp" --><%
	Response.end
	
	
	
	Response.End
	End Select
%>
