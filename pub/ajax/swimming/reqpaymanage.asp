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
		REQ ="{""CMD"":400}"
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


	CMD_ATTINFO = 12000 '참가자정보창
	CMD_PAYCANCEL = 500
	CMD_SETOK = 550

	Select Case CDbl(CMD)
	Case CMD_SETOK '승인확인 토글
		%><!-- #include virtual = "/pub/api/swimmingAdmin/paymanage/api.okeyonoff.asp" --><%
	Response.end
	
	Case CMD_PAYCANCEL '취소요청 확인후 완료
		%><!-- #include virtual = "/pub/api/swimmingAdmin/paymanage/api.paycancel.asp" --><%
	Response.end

	Case CMD_ATTINFO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/paymanage/api.attinfo.asp" --><%
	Response.end
	End Select
%>
