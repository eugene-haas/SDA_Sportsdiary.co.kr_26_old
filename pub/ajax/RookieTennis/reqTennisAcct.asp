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
		REQ =  "{""title"":""인천송도1차 2019 제1회 원카 SD랭킹 Rookie Tennis Championship "",""vacct"":""23497381490637"",""money"":""60000"",""name"":""이기영"",""phone"":""01050360549"",""CMD"":10}" 
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
	CMD_ACCTINFO =30027		'결제정보
	CMD_ACCTMSG = 30025	'계좌문자보내기
	CMD_ACCTMSGSEND = 10			'계좌문자보내기

	CMD_REFUNDWIN =30028 '관리자 결제자 취소시 정보입력

	'define  0 예선 1 예선대진표완료 2본선진출 3 본선대진표완료 4본선대진완료 (sd_TennisMember gubun)
	LEAGUESET = 0
	LEAGUESTART = 1
	TOURNSET = 2
	TOURNSTART = 3
	RESULTHIDE = 4
	RESULTSHOW = 5

	STARTROUND = 1 '시작라운드



	Select Case CDbl(CMD)

	Case CMD_REFUNDWIN
	%><!-- #include virtual = "/pub/api/RookieTennisAdmin/vacct/api.refundwin.asp" --><%
	Response.End

	Case CMD_ACCTMSGSEND
	%><!-- #include virtual = "/pub/api/RookieTennisAdmin/vacct/api.AcctMsgSend.asp" --><%
	Response.End
	
	Case CMD_ACCTMSG
	%><!-- #include virtual = "/pub/api/RookieTennisAdmin/vacct/api.AcctMsg.asp" --><%
	Response.End
	
	Case CMD_ACCTINFO
	%><!-- #include virtual = "/pub/api/RookieTennisAdmin/vacct/api.VAcctInfo.asp" --><%
	Response.End
	End Select
%>