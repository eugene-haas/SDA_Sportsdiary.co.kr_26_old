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
		REQ ="{""CMD"":30001,""PARR"":[""01"",""N"",""서울"",""서울"",""서울"",""서울"",""서울"",""서울시 대회참가신청테스트"","""",""01"",""8"",""JH2019"",""500"",""2020/03/25 - 2020/03/31"",""2020/04/2100:00:21 - 2020/12/3100:00:31"",""01"",""01"",""Y"","""",""Y"","""",""Y"",""4""]}"
	Else
		REQ = request("REQ")
	End if
	'REQ ="{""CMD"":30002,""IDX"":49}"

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if

	'define CMD
	 CMD_GAMEINPUT = 30001
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 30003
	CMD_GAMEINPUTDEL = 30004
	CMD_BTNST = 100 '플레그 토글

	CMD_SETBEA	 = 40000
	CMD_PRINT = 60001	'인쇄	

	Select Case CDbl(CMD)

	Case CMD_PRINT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.crape.asp" --><%
	Response.end
	


	Case CMD_SETBEA
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.setbea.asp" --><%
	Response.end
	
	
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.gameinput.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.gameinputedit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.gameinputeditok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.gameinputdel.asp" --><%
	Response.end


	Case CMD_BTNST
	%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.setFlag.asp" --><%
	Response.End

	End select
%>
