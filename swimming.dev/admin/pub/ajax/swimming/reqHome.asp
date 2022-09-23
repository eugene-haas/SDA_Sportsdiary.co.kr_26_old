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
		REQ ="{""CMD"":10001,""SELECTYEAR"":[""2020"",""2019""],""PIDX"":53865}"
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


	CMD_SENDSMS = 100	'핸드폰 인증 (등록된 코치인지 확인)
	CMD_CHECKSMS = 200	'인증번호가 맞는지
	CMD_MLIST = 11000		'선수 리스트 
	CMD_SETMLIST =300	'목록설정
	CMD_BOOLIST = 12000	'부목록
	CMD_SETBLIST = 400	'부설정
	CMD_DELKIND = 500		'종목삭제
	CMD_SETREFUND = 600 '결제취소요청 (88)

	CMD_PAYCANCELLIST = 13000 '취소정보입력화면

	'증명서 발급 관련
	CMD_SENDSMS_CER = 101	'핸드폰 인증 (등록된 코치인지 확인)
	CMD_SETCINFO = 222 'temp 정보저장

	CMD_SETGAMETITLE = 10001	'선택년도 대회명 가져오기
	CMD_PRINT = 60001	'인쇄

	CMD_SETOK = 700 '다이빙, 아티스틱 단체 명수 체크

	Select Case CDbl(CMD)

	Case CMD_SETOK
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.setBooCheck.asp" --><%
	Response.End

	Case CMD_PRINT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.print.asp" --><%
	Response.End


	Case CMD_SETREFUND
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.setrefund.asp" --><% '결제취소 요청
	Response.End

	Case CMD_PAYCANCELLIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.payCancelModal.asp" --><%
	Response.End


	Case CMD_SENDSMS
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.pnoCheck.asp" --><% 
	Response.end	

	Case CMD_CHECKSMS
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.pnoCheckNo.asp" --><% '공통
	Response.End

	Case CMD_MLIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.Playerlist.asp" --><%
	Response.End

	Case CMD_SETMLIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.SetPlayer.asp" --><%
	Response.End
	
	Case CMD_BOOLIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.boolist.asp" --><%
	Response.End
	
	Case CMD_SETBLIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.SetBoo.asp" --><%
	Response.End	

	Case CMD_DELKIND
		%><!-- #include virtual = "/pub/api/swimmingAdmin/att/api.delKIND.asp" --><%
	Response.End	
	
	End Select
%>
