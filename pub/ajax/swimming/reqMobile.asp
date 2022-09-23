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
		'REQ = "{""CMD"": ""63400"",""tidx"": ""146"",""PN"": ""1"",""PT"": ""N"",""YS"": ""2019"",""MS"": ""3"",""poplink"": ""4"",""vidx"":"""",""searchtxt"":"""",""gno"":""1""}"
		REQ = "{""CMD"":20090,""TIDX"":141,""RCCODE"":""R07"",""BOONM"":""자유형""}"
	else
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

	'define CMD
	CMD_MAINVIEW = 50000 '메인뷰
	CMD_GAMEGETDATEPOP = 62000 '경기일정 팝업
	CMD_PLAYERLIST = 63300 '선수목록
	CMD_GAMEGETDATE = 60000 '경기일정 월별

	CMD_TEAMATTMEMBER = 20000 '팀 참여목록
	CMD_TEAMLIST = 20010 '팀리스트
	CMD_CDALIST = 20020 'CDA 리스트
	CMD_GETATTMEMBER = 20030 '종목별 참가신청리스트
	CMD_GETMATCHTABLE = 20040 '대진표가져요기
	CMD_GETMATCHTABLEJOO = 20050
	CMD_GETMATCHTABLEFIND = 20060 '검색한 이름으로 대진표 출력
	CMD_GETORDERTABLEFIND = 20070 '경기순서 선수 검색
	CMD_GETRESULTTABLEFIND = 20080 '대회결과 선수로 검색
	CMD_GETRC = 20090 '신기록검색

	CMD_GETFINDTEAM = 120 '팀목록찾기
	CMD_GETFINDPLAYER = 130 '선수명으로 찾기
	CMD_GETPLAYERTABLE = 140 '선수명으로 참여한 대진표 찾기

	CMD_GAMEINRC = 13000 '결과화면
	CMD_TNMAKE = 700
	CMD_SECTIONINFO = 13001 '구간기록목록
	Select Case CDbl(CMD)

			Case CMD_SECTIONINFO
				%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.sectioninfo.asp" --><%
			Response.End

			Case CMD_TNMAKE
				%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.tnTable.asp" --><%
			Response.End

			Case CMD_GAMEINRC
				%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.soogooWindow.asp" --><%
			Response.End



		Case CMD_GAMEGETDATE
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.gameGetDate.asp" --><%
			Response.end
		Case CMD_PLAYERLIST
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.PlayerList.asp" --><%
			Response.end
		Case CMD_MAINVIEW
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.MainView.asp" --><%
			Response.end
		Case CMD_GAMEGETDATEPOP
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.gameGetDate_pop.asp" --><%
			Response.end


		Case CMD_TEAMATTMEMBER '팀 참가신청 명단
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.TeamAttMember.asp" --><%
			Response.End
		Case CMD_TEAMLIST '팀명단
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.TeamList.asp" --><%
			Response.end
		Case CMD_GETFINDTEAM '침목록찾기
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.attTeamFind.asp" --><%
			Response.end
		Case CMD_GETFINDPLAYER '침목록찾기
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.attPlayerFind.asp" --><%
			Response.end

		Case CMD_GETPLAYERTABLE '선수명으로 참여한 대진표 찾기
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.attPlayerTable.asp" --><%
			Response.end


		Case CMD_CDALIST
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.cdalist.asp" --><%
			Response.end

		Case CMD_GETATTMEMBER
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.getAttMember.asp" --><%
			Response.End
		Case CMD_GETMATCHTABLE
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.getmatchtable.asp" --><%
			Response.End
		Case CMD_GETMATCHTABLEJOO
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.getmatchtablejoo.asp" --><% '조가있다 (대상: 경영)
			Response.End

		Case CMD_GETMATCHTABLEFIND
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.getmatchtableFind.asp" --><%
			Response.End

		Case CMD_GETRESULTTABLEFIND '대회결과 선수로 검색
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.getResultTableFind.asp" --><%
			Response.End

		Case CMD_GETORDERTABLEFIND
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.getordertableFind.asp" --><%
			Response.End

		Case CMD_GETRC
			%><!-- #include virtual = "/pub/api/swimmingAdmin/mobile/api.getSin.asp" --><%
			Response.End




	End Select
%>
