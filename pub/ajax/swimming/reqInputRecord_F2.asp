<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->

<!-- #include virtual = "/pub/fn/fn.swjudge.F2.asp" -->


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



	CMD_SETTKTOTALDEDUCTION = 78 '테크(1라운드) 감점 0.5
	CMD_SETELETOTALDEDUCTION = 80	'엘리먼트총감점 감점상태변경
  CMD_SETTOTALDEDUCTION = 82	'총감점 전체에서 감점
	CMD_SETELEDEDUCTION = 84	'엘리먼트 마다 0.5



	CMD_SETROUNDOUT = 90	'실격상태변경
	CMD_SETOUT = 410  '실격사유선택(전체)
	CMD_SETROUNDVALUE = 420	'심판별 각라운드 점수 입력
	CMD_SETROUNDZEROAVG = 87	'0점 인원 평균값으로 만들기(심판이 판단해서)

	CMD_SENDRESULT = 610	'실적전송
	CMD_SETAPPYN = 630 '앱노출여부 (오전, 오후)



	Select Case CDbl(CMD)

	Case CMD_SENDRESULT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.sendresult.asp" --><%
	Response.End

	Case CMD_SETAPPYN
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.setOpenApp.asp" --><%
	Response.End



	Case CMD_SETROUNDZEROAVG '0점 인원 평균값으로 만들기(심판이 판단해서)
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.setroundzeroavg.asp" --><% 
	Response.End	


	Case CMD_SETROUNDVALUE '심판별 각라운드 점수 입력
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.setRoundValue.asp" --><% 
	Response.End

	Case CMD_SETOUT '실격사유선택(전체)
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.setTotalOut.asp" --><% 
	Response.End

	Case CMD_GETGAMELIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.InputList.asp" --><% 
	Response.End
	Case CMD_JUDGEWINDOW '심사기록창
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.judgeWindow.asp" --><%
	Response.End

	Case CMD_CHANGEREFEREEWINDOW '심판수정창
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.changerefereewindow.asp" --><%
	Response.End
	Case CMD_CHANGEREFEREEOK '심판수정
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.changereferee.asp" --><%
	Response.End

	Case CMD_SETTKTOTALDEDUCTION '테크 1라운드 총점 감점 0.5
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.tktotaldeduction.asp" --><% 
	Response.End

	Case CMD_SETELETOTALDEDUCTION '엘리먼트 총점 감점 2.5
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.eletotaldeduction.asp" --><% 
	Response.End

	Case CMD_SETTOTALDEDUCTION '총점 감점 0.5~~~ 최대 6
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.totaldeduction.asp" --><% 
	Response.End

Case CMD_SETELEDEDUCTION '각 엘리먼트 감점 0.5
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.elededuction.asp" --><% 
	Response.End	


	Case CMD_SETROUNDOUT '실격
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/F2IN/api.setroundout.asp" --><%
	Response.End




	End Select
%>
