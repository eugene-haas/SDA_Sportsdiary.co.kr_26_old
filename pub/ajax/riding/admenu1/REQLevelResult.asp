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
		 REQ = "{""CMD"":20000,""IDX"":547,""TIDX"":119,""TITLE"":""루키"",""LEVELNO"":""20104009"",""TeamNM"":""남자부★"",""AreaNM"":""수원""}"
		
		'REQ = "{""CMD"":20000,""IDX"":323,""TIDX"":59,""TITLE"":""2018 분당위너스 단체전"",""LEVELNO"":""20120001"",""TeamNM"":""단체부"",""AreaNM"":""성남""}"
		'REQ = "{""CMD"":300,""LEVELNO"":20102004,""IDX"":477,""TIDX"":87,""TITLE"":""2018 강화섬쌀배"",""TeamNM"":""국화부"",""AreaNM"":""강화""}" '지움
		'REQ = "{""CMD"":20000,""IDX"":477,""TIDX"":87,""TITLE"":""2018 강화섬쌀배"",""LEVELNO"":20102004,""TeamNM"":""국화부"",""AreaNM"":""강화""}" '새로생성

		'REQ = "{""CMD"":300,""LEVELNO"":20101007,""IDX"":276,""TIDX"":43,""TITLE"":""2018 코사모배"",""TeamNM"":""개나리부"",""AreaNM"":""최종라운드""}"

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

	CMD_MAKEGOODS = 50000 ' 상품등록창 오픈
	CMD_INSERTDEP1 = 50002 '저장
	Select Case CDbl(CMD)


	Case CMD_MAKEGOODS
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.goodsForm.asp" --><%
	Response.end	
	Case CMD_INSERTDEP1
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.goodsFormOK.asp" --><%
	Response.end	


	Case CMD_RESETRANK
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.resetRank.asp" --><%
	Response.end	

	Case CMD_SETRANK
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setRank.asp" --><%
	Response.end	


	Case CMD_PROCESSRESULT

		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.gameResult.asp" --><%
	Response.end	

	Case CMD_SETGAME
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setGame.asp" --><%
	Response.end	


	Case CMD_SETRANKER
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.setGameRanker.asp" --><%
	Response.end	

	Case CMD_DELRANKER
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.delGameRanker.asp" --><%
	Response.end	


	Case CMD_CHANGERANK
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.changeRank.asp" --><%
	Response.end	

	Case CMD_CHANGEPOINT
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.changePoint.asp" --><%
	Response.end	

    

	End Select
%>