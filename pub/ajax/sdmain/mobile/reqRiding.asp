<!-- #include virtual = "/pub/header.ridingAdmin.asp" -->
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
		REQ = "{""CMD"": ""10000"",""id"": ""player11""}"
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
	CMD_RIDINGMYPAGEVIEW = 10000 '승마 마이페이지 정보
	CMD_RIDINGMYPAGEUP = 11000 '마이페이지 정보


	Select Case CDbl(CMD)

		Case CMD_RIDINGMYPAGEVIEW
			%><!-- #include virtual = "/pub/api/sdmain/mobile/api.ridingMypageView.asp" --><%
			Response.end
		Case CMD_RIDINGMYPAGEUP
			%><!-- #include virtual = "/pub/api/sdmain/mobile/api.ridingMypageUp.asp" --><%
			Response.end

	End Select
%>
