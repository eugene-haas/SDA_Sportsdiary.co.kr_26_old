<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->

<!-- #include virtual = "/pub/fn/fn.swjudge.asp" -->


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
		REQ = "{""CMD"":11000,""AMPM"":""am"",""LIDX"":11383,""GUBUN"":""3""}"
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

	CMD_GETGAMELIST = 11000
	CMD_JUDGEWINDOW = 20010	'심사기록창
	CMD_CHANGEREFEREEWINDOW = 20008 '심판수정창
	CMD_CHANGEREFEREEOK = 75 '심판수정
	CMD_SETROUNDDEDUCTION = 80	'감점상태변경
	CMD_SETROUNDOUT = 90	'실격상태변경
	CMD_SETOUT = 410  '실격사유선택(전체)
	CMD_SETROUNDVALUE = 420	'심판별 각라운드 점수 입력

	CMD_SETROUNDEND = 85	'진행완료만들기
	CMD_SETROUNDZEROAVG = 87	'0점 인원 평균값으로 만들기(심판이 판단해서)

	CMD_SENDRESULT = 610	'실적전송
	CMD_SETAPPYN = 630 '앱노출여부 (오전, 오후)
	CMD_ORDERLIST = 30010
	CMD_FINDMEMBER = 30020
	
	CMD_CHANGEMEMBER = 710


	Select Case CDbl(CMD)
	Case CMD_CHANGEMEMBER '선수변경
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.changemember.asp" --><%
	Response.End	

	Case CMD_FINDMEMBER
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.findmember.asp" --><%
	Response.End	

	Case CMD_ORDERLIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.changeMemberWindow.asp" --><%
		Response.End


	Case CMD_SENDRESULT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.sendresult.asp" --><%
	Response.End

	Case CMD_SETAPPYN
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.setOpenApp.asp" --><%
	Response.End



	Case CMD_SETROUNDEND '진행완료만들기
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.setroundend.asp" --><% 
	Response.End
	Case CMD_SETROUNDZEROAVG '0점 인원 평균값으로 만들기(심판이 판단해서)
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.setroundzeroavg.asp" --><% 
	Response.End	


	Case CMD_SETROUNDVALUE '심판별 각라운드 점수 입력
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.setRoundValueE2.asp" --><% 
	Response.End

	Case CMD_SETOUT '실격사유선택(전체)
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.setTotalOutE2.asp" --><% 
	Response.End

	Case CMD_GETGAMELIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.E2_InputList.asp" --><% 
	Response.End
	Case CMD_JUDGEWINDOW '심사기록창
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.judgeWindow.asp" --><%
	Response.End

	Case CMD_CHANGEREFEREEWINDOW '심판수정창
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.changerefereewindow.asp" --><%
	Response.End
	Case CMD_CHANGEREFEREEOK '심판수정
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.changereferee.asp" --><%
	Response.End

	Case CMD_SETROUNDDEDUCTION '감점
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.setrounddeduction.asp" --><% 
	Response.End
	Case CMD_SETROUNDOUT '실격
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.setroundout.asp" --><%
	Response.End









	End Select
%>
