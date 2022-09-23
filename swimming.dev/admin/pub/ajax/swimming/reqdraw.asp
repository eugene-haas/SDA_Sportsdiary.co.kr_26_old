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
		'REQ ="{""TABLETYPE"":2,""CMD"":700,""TIDX"":78,""LNO"":""E2U31"",""TNO"":8,""CALLTYPE"":""make""}"
		REQ = "{""CMD"":502,""TIDX"":129,""GBIDX"":44951,""CDC"":""01"",""CHKLIDX"":[""78"",""121"",""122"",""123"",""124""]}"

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

	CMD_FINDBOODETAIL = 11000 '세부종목 불러오기
	CMD_FINDBOO = 11001	'부

	CMD_GAMEINPUT = 301
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 303
	CMD_GAMEINPUTDEL = 304
	CMD_GETBESTRC = 502 '기준기록반영
	CMD_SETRANE = 510 '레인배정

	CMD_GAMEBESTLIST = 12100 '신기록조회
	CMD_GAMEEXLLIST = 12200 '엑셀리스트
	
	CMD_GAMELIST = 12000	'기준기록조회
	CMD_GAMELISTSEARCH = 12001
	CMD_GAMELISTSEARCH2 = 12002
	CMD_CHANGERANE = 310 '레인베정바꾸기 
	CMD_CHANGERANEJOO = 311 '레인+조베정바꾸기 
	CMD_CHANGENO = 320	'대진순서 설정



	CMD_LGMAKE = 70000		'리그테이블
	CMD_TNMAKE = 700			'토너먼트 테이블

	CMD_GAMEINRC = 13000	'게임결과 입력

	CMD_SETSCORE = 800 '점수저장
	CMD_SETSAVESOOGOO = 810 '수구승패저장
	CMD_SETLEGORDER = 603  '순위 강제지정
	CMD_SENDRC  = 604	'수구실적전송
	CMD_SETAPPYN = 630 '앱노출여부 (오전, 오후)
	CMD_SETSTART = 669 '경기시작형태

	Select Case CDbl(CMD)

	Case CMD_SETSTART
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.setStart.asp" --><%
	Response.End

	Case CMD_SETAPPYN
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.setOpenApp.asp" --><%
	Response.End

	Case CMD_SENDRC '수구 실적전송 (저장및)
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.sendResultSG.asp" --><%
	Response.End

	Case CMD_SETLEGORDER
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.setlegorder.asp" --><%
	Response.End

	Case CMD_SETSAVESOOGOO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.setSaveSooGoo.asp" --><%
	Response.End



	Case CMD_SETSCORE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.setscore.asp" --><%
	Response.End


	Case CMD_GAMEINRC
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.soogooWindow.asp" --><%
	Response.End



	Case CMD_LGMAKE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.lgTable.asp" --><% 	'리그만들기 
	Response.End

	Case CMD_TNMAKE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.tnTable.asp" --><%	'토너먼트 만들기 
	Response.End


	Case CMD_CHANGENO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.changeno.asp" --><%
	Response.End

	Case CMD_CHANGERANE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.changerane.asp" --><%
	Response.End
	Case CMD_CHANGERANEJOO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.changeranejoo.asp" --><%
	Response.End

	Case CMD_SETRANE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.setrane.asp" --><%
	Response.End

	Case CMD_GETBESTRC
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.getbestrc.asp" --><%
	Response.End


	Case CMD_GAMEEXLLIST ,CMD_GAMELISTSEARCH2 '신기록조회 '엑셀
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.exlgamelist.asp" --><%
	Response.End	

	Case CMD_GAMEBESTLIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.BestGamelist.asp" --><%
	Response.End	
	
	Case CMD_GAMELIST,CMD_GAMELISTSEARCH
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.basegamelist.asp" --><%
	Response.End
	
	End Select
%>
