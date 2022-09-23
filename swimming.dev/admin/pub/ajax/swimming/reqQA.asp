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
		REQ ="{""CMD"":303,""PARR"":["""","""",""백승kkkk"",""韓k"",""eeek"",""2019-12-03"",""2"",""대한민국"",""01"",""F2"",""3"",""fdfdsfsd"",""1"",""SW00833"",""20996""]}"
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

	CMD_FINDTEAM = 30008 '소속검색
	CMD_UIINPUT = 201
	CMD_GAMEINPUT = 301
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 303
	CMD_GAMEINPUTDEL = 304
	CMD_SETVAL = 100
	CMD_LINEDEL = 305
	



	Select Case CDbl(CMD)
	Case CMD_SETVAL
		%><!-- #include virtual = "/pub/api/QA/api.setval.asp" --><%
	Response.end	
	Case CMD_UIINPUT
		%><!-- #include virtual = "/pub/api/QA/api.UIwrite.asp" --><%
	Response.end

	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/QA/api.QAwrite.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/QA/api.QAedit.asp" --><%
	Response.end

	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/QA/api.QAdel.asp" --><%
	Response.End
	
	Case CMD_LINEDEL
		%><!-- #include virtual = "/pub/api/QA/api.LINEdel.asp" --><%
	Response.end
	
	
	
	End Select
%>
