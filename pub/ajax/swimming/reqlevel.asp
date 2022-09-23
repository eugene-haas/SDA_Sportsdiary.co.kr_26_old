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
		REQ ="{""CMD"":303,""PARR"":[""D2"",""I"",""2"",""X"",""04"",""104"",""7251""]}"
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

	CMD_FINDBOODETAIL = 11000 '세부종목 불러오기
	CMD_FINDBOO = 11001	'부

	CMD_GAMEINPUT = 301
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 303
	CMD_GAMEINPUTDEL = 304
	CMD_GAMELEVELCOPY = 500 '게임복사

	CMD_GAMECOPY = 12000	'타대회복사 할 목록
	CMD_GAMECOPYSEARCH = 12001

	Select Case CDbl(CMD)
	Case CMD_GAMELEVELCOPY
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contestlevel/api.gamecopy.asp" --><%
	Response.End

	Case CMD_GAMECOPY,CMD_GAMECOPYSEARCH
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contestlevel/api.copygamelist.asp" --><%
	Response.End
	
	Case CMD_FINDBOO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contestlevel/api.booLoad.asp" --><%
	Response.End

	Case CMD_FINDBOODETAIL
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contestlevel/api.booDetailLoad.asp" --><%
	Response.End
	
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contestlevel/api.gameinputLevel.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contestlevel/api.gameinputLeveledit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contestlevel/api.gameinputLeveleditok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contestlevel/api.gameinputLevelDel.asp" --><%
	Response.end
	
	
	
	Response.End
	End Select
%>
