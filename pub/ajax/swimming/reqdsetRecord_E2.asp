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


	CMD_REFEREEWINDOW = 20000
	CMD_SETREFEREE = 70
	CMD_GETGAMELIST = 11000
	CMD_SETGAMEROUND = 50 '라운드설정
	CMD_SETJUDGECNT = 51
	CMD_SUMBOO = 53 '부통합
	CMD_SETGAMEPER = 55 '난이율 인덱스
	CMD_SETGAMEDATE2 = 57 '날짜설정
	CMD_SETAMPM = 59 '시간으로
	CMD_DIVBOO = 61 '해제
	CMD_CHANGEORDER = 63 '경기순서변경
	CMD_FINDJUDGE = 20003	'심판불러오기 20개만..
	CMD_SETJUDGE = 20005 '심판등록
	CMD_DELJUDGE = 65
	CMD_CHANGEREFEREEWINDOW = 20008 '심판수정창
	CMD_CHANGEREFEREEOK = 75 '심판수정
	CMD_CHANGEMEMBERORDER = 310 '순서변경
	CMD_GAMECODEWINDOW = 20012 '난이율코드등록창
	
	CMD_TEMPORDER = 64 '임시경기번호저장	
	CMD_SETGAMENO = 66	'경기번호 일괄적용
	CMD_SETJUDGEALL = 71 '심판전체배정


	CMD_SEACHGAMECODE = 20030

	Select Case CDbl(CMD)
	Case CMD_SEACHGAMECODE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.findgamecode.asp" --><%
	Response.End	

	Case CMD_TEMPORDER
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.temporder.asp" --><%
	Response.End	
	Case CMD_SETGAMENO 
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.setgameno.asp" --><%
	Response.End
	Case CMD_SETJUDGEALL '배정심판배치
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.setjudgeall.asp" --><%
	Response.end	
	

	Case CMD_GAMECODEWINDOW 
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.gamecodewindow.asp" --><%
	Response.End


	Case CMD_CHANGEREFEREEWINDOW '심판수정창
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.changerefereewindow.asp" --><%
	Response.End

	Case CMD_CHANGEREFEREEOK '심판수정
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2IN/api.changereferee.asp" --><%
	Response.End


	Case CMD_REFEREEWINDOW '심판배정윈도우
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.refereewindow.asp" --><%
	Response.End
	Case CMD_SETREFEREE '배정심판배치
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.setreferee.asp" --><%
	Response.end	



	Case CMD_GETGAMELIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.E2_SETList.asp" --><% 
	Response.End

	Case CMD_SETGAMEROUND
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.setgameround.asp" --><%
	Response.End

	Case CMD_SETJUDGECNT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.setjudgecnt.asp" --><%
	Response.End
	Case CMD_SUMBOO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.sumboo.asp" --><%
	Response.End
	Case CMD_SETGAMEPER
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.setgameper.asp" --><%
	Response.End
	Case CMD_SETGAMEDATE2
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.setgamedate2.asp" --><%
	Response.End
	Case CMD_SETAMPM
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.setampm.asp" --><%
	Response.End
	Case CMD_DIVBOO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.divboo.asp" --><%
	Response.End
	Case CMD_CHANGEORDER
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.changeorder.asp" --><%
	Response.End

	Case CMD_FINDJUDGE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.findjudge.asp" --><%
	Response.End
	Case CMD_SETJUDGE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.setjudge.asp" --><%
	Response.End
	Case CMD_DELJUDGE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.deljudge.asp" --><%
	Response.End

	Case CMD_CHANGEMEMBERORDER '선수 순서변경
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/E2/api.changeMemberOrder.asp" --><%
	Response.End


	End Select
%>
