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
		REQ =  "{""CMD"":40000,""NKEY"":0,""FSTR"":""21"",""FSTR2"":""20103005,베테랑부"",""SHEETNO"":0,""FNM"":""pazoo.xlsx""}" 

	ElseIf request("test") = "z" Then
		REQ ="{""CMD"":30017,""IDX"":52,""RESET"":""notok"",""TitleIDX"":13,""Title"":""송근호배"",""TeamNM"":""오픈부"",""AreaNM"":""목동"",""MEMBERIDX"":""2269"",""STR"":""2"",""RNDNO"":""2""}"
	else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
	Set oJSONoutput = JSON.Parse(REQ)
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if

	'define CMD
	CMD_FIND1 = 30005
	CMD_SHEETSHOW = 30006
	CMD_SETGAME = 40000
	CMD_DELGAME = 40001


	Select Case CDbl(CMD)
	Case CMD_FIND1
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.upgameFind1.asp" --><%
	Response.end	
	Case CMD_SHEETSHOW
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.selectSheet.asp" --><%
	Response.end	

	Case CMD_SETGAME
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setGame.asp" --><%
	Response.end	

	Case CMD_DELGAME
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.delGame.asp" --><%
	Response.end	

	End Select
%>