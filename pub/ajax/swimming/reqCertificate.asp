<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
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
		REQ ="{""CMD"":60001,""SEQ"":62}"
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



	CMD_CHECKSMS = 200	'인증번호가 맞는지



	'증명서 발급 관련
	CMD_SENDSMS_CER = 101	'핸드폰 인증 (등록된 코치인지 확인)
	CMD_SETCINFO = 222 'temp 정보저장
	CMD_SETGAMETITLE = 10001	'선택년도 대회명 가져오기
	CMD_PRINT = 60001	'인쇄
	CMD_PRINTPRE = 60002 '인쇄미리보기

	Select Case CDbl(CMD)

	'증명서 발급 관련 s
	Case CMD_SENDSMS_CER
		%><!-- #include virtual = "/pub/api/swimmingAdmin/certificate/api.pnoCheckplayer.asp" --><% 
	Response.end	
	Case CMD_SETCINFO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/certificate/api.setCinfo.asp" --><% 
	Response.end	
	Case CMD_SETGAMETITLE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/certificate/api.gamelist.asp" --><%
	Response.End

	Case CMD_PRINT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/certificate/api.print.asp" --><%
	Response.End

	Case CMD_PRINTPRE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/certificate/api.print_pre.asp" --><%
	Response.End

	'증명서 발급 관련 e




	Case CMD_CHECKSMS
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.pnoCheckNo.asp" --><% '공통
	Response.End


	
	End Select
%>
