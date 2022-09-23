<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

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
		REQ =  "{""CMD"":70000,""NKEY"":0,""result"":""0""}" 

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
	CMD_SETPLYER = 40000
	CMD_DELPN = 50000
	CMD_COPYPHONENO = 60000
	CMD_MERGETABLE = 70000

	Select Case CDbl(CMD)

	Case CMD_MERGETABLE
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/tool/api.mergetable.asp" --><%
	Response.end	

	Case CMD_COPYPHONENO
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/tool/api.copyPhoneNo.asp" --><%
	Response.end	

	Case CMD_DELPN
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/tool/api.delpn.asp" --><%
	Response.end	

	Case CMD_SETPLYER
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/tool/api.setPlayer.asp" --><%
	Response.end	



	End Select
%>