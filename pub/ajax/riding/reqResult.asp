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
    REQ = "{""CMD"":101,""SVAL"":""20190001"",""IDXARR"":[15086,15081,15077]}" 
	else
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

	'define CMD
	CMD_SETRELOAD = 100
	CMD_SETPRICE = 200 '상금설정
	CMD_SETPOINTWIN = 20000
	CMD_SETPOINT = 300
    'CMD_EDIT = 50002	'내용불러오기
	CMD_CRAPENO = 101

	Select Case CDbl(CMD)
	case CMD_SETPOINTWIN
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setpointwindow.asp" --><% 
	Response.End
	case CMD_SETPOINT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setpoint.asp" --><% 
	Response.End

	case CMD_SETPRICE
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setPrice.asp" --><%  '상금 설정
	Response.End

	Case CMD_CRAPENO
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.crapeNo.asp" --><%
	Response.End




	End Select
%>
