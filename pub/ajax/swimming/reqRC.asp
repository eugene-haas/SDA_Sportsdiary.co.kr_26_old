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
		REQ ="{""CMD"":303,""PARR"":[""4444"",""ㅎㅎㅎ"",""55ㅇ"",""2020-01-07"",""백소이"",""부일중학교"",""2"",""876543"",""1"",""R01"",""D2"",""T"",""2"",""]"",""10"",""201203000362"",""SW00471"",""12139"",""2"",""경기"",""08"",""12""]}"
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

	CMD_FINDPLAYER = 30008
	CMD_FINDTEAM = 30009 '소속검색

	CMD_GAMEINPUT = 301
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 303
	CMD_GAMEINPUTDEL = 304

	CMD_FINDBOODETAIL = 11000 '세부종목 불러오기
	CMD_FINDBOO = 11001	'부
	CMD_GETLIST = 310000 '목록불러오기

	Select Case CDbl(CMD)

	Case CMD_GETLIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/rc/api.getlist.asp" --><%
	Response.End


	Case CMD_FINDBOO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/rc/api.booLoad.asp" --><%
	Response.End

	Case CMD_FINDBOODETAIL
		%><!-- #include virtual = "/pub/api/swimmingAdmin/rc/api.booDetailLoad.asp" --><%
	Response.End
	
	Case CMD_FINDTEAM
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.TeamFind.asp" --><%
	Response.end		

	Case CMD_FINDPLAYER
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.PlayerFind.asp" --><%
	Response.end	
	



	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/rc/api.rcInput.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/rc/api.rcInputedit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/swimmingAdmin/rc/api.rcInputeditok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/swimmingAdmin/rc/api.rcDel.asp" --><%
	Response.end
	
	
	
	End Select
%>
