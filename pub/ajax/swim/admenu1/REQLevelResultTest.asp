<!-- #include virtual = "/pub/header.swimAdmin.asp" -->
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
		'http://tennis.sportsdiary.co.kr/pub/ajax/admenu1/reqlevelresult.asp?test=t
		REQ = "{""CMD"":20000,""IDX"":333,""TIDX"":50,""TITLE"":""2018 NH농협은행배"",""LEVELNO"":""20105007"",""TeamNM"":""오픈부"",""AreaNM"":""최종라운드""}"

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
	CMD_PROCESSRESULT = 20000 '부별 대회결과처리 화면
	CMD_SETRANKER = 30000 '생성 (참가지인지 확인 필요)
	CMD_DELRANKER = 30001

	CMD_CHANGERANK = 100
	CMD_CHANGEPOINT = 200
	CMD_RESETRANK = 300 '랭킹지우고 재산정

	CMD_SETGAME = 40000 '포인트 적용 인터페이스 로그 대상자 일괄저장 (참가자 일괄 인서트 sd_TennisScore)
	CMD_SETRANK = 40001 '포인트 순차적용
	Select Case CDbl(CMD)


	Case CMD_RESETRANK
		%><!-- #include virtual = "/pub/api/swimadmin/gameresult/api.resetRank.asp" --><%
	Response.end	

	Case CMD_SETRANK
		%><!-- #include virtual = "/pub/api/swimadmin/gameresult/api.setRank.asp" --><%
	Response.end	


	Case CMD_PROCESSRESULT
		%><!-- #include virtual = "/pub/api/swimadmin/gameresult/api.gameResultTest.asp" --><%
	Response.end	

	Case CMD_SETGAME
		%><!-- #include virtual = "/pub/api/swimadmin/gameresult/api.setGame.asp" --><%
	Response.end	


	Case CMD_SETRANKER
		%><!-- #include virtual = "/pub/api/swimadmin/gameresult/api.setGameRanker.asp" --><%
	Response.end	

	Case CMD_DELRANKER
		%><!-- #include virtual = "/pub/api/swimadmin/gameresult/api.delGameRanker.asp" --><%
	Response.end	


	Case CMD_CHANGERANK
		%><!-- #include virtual = "/pub/api/swimadmin/gameresult/api.changeRank.asp" --><%
	Response.end	

	Case CMD_CHANGEPOINT
		%><!-- #include virtual = "/pub/api/swimadmin/gameresult/api.changePoint.asp" --><%
	Response.end	

    

	End Select
%>