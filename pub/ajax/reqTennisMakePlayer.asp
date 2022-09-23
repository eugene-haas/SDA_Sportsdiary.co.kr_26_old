<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
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
		REQ = "{""CMD"":500}"
        'REQ = "{""CMD"":40012,""PIDX"":6741,""PNAME"":""백승훈"",""PTITLE"":""TEST""}"
        'REQ = "{""CMD"":610,""PIDX"":6741,""PNAME"":""백승훈"",""RNKYN"":""Y"",""RNKSTART"":""2018-06-01"",""RNKEND"":""2019-09-15""}"
        ' REQ = "{""CMD"":400,""PIDX"":""6741"",""V"":""51"",""TITLECODE"":""51""}"
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
	CMD_AUTOCOMPLETE = 100

	CMD_CONTESTAPPEND = 30000
	CMD_GAMEINPUT = 30001
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 30003
	CMD_GAMEINPUTDEL = 30004
	'CMD_FIND1 = 30005
	'CMD_FIND2 = 30006
	CMD_GAMEAUTO = 30007
	CMD_FINDPLAYER = 30008
	'CMD_FINDRANK = 30009

	CMD_RANKINGINPUT = 30010
	CMD_RANKPOINT = 30011

	CMD_INFOCHANGE = 40000 '정보변경요청 리스트
	CMD_HELP = 40001 '도움말창

	CMD_WORKOK = 200 '작업완료
	CMD_DELOK = 201 '작업완료
	CMD_RNKBOO = 202 '랭킹부

	CMD_PLAYEREDITOK = 50001 '선수정보수정, 대회신청자 정보수정

	CMD_OPENRNK = 300 '오픈부 랭킹반영부서
	CMD_UPGRADE = 400 '승급자설정
	CMD_RESETUP = 500 '승급자 전체정보 리셋

	CMD_SUMPPOINT = 40002 '포인트 합침창
	CMD_SUMPPOINTOK = 600 '포인트 합침

	CMD_SETRANKER = 40012 '외부승급자 설정 화면
	CMD_SETRANKEROK = 610 '외부승급자설정
    CMD_PROCESSRESULT = 40013 '부별 대회결과처리 화면


	Select Case CDbl(CMD)

	Case CMD_SETRANKER
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.setranker.asp" --><%
	Response.End

	Case CMD_SETRANKEROK
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.setrankerOK.asp" --><%
	Response.End




	Case CMD_OPENRNK
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.openrnk.asp" --><%
	Response.End
	Case CMD_UPGRADE
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.upgrade.asp" --><%
	Response.End
	Case CMD_RESETUP
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.resetup.asp" --><%
	Response.End

	Case CMD_SUMPPOINT
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.sumpoint.asp" --><%
	Response.End

	Case CMD_SUMPPOINTOK
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.sumpointOK.asp" --><%
	Response.End



	Case CMD_RNKBOO
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.rankboo.asp" --><%
	Response.end

	Case CMD_PLAYEREDITOK
		%><!-- #include virtual = "/pub/api/tennisadmin/api.rankPlayerEdit.asp" --><%
	Response.end

	Case CMD_WORKOK,CMD_DELOK
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.workok.asp" --><%
	Response.End

	Case CMD_INFOCHANGE
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.infoChangeList.asp" --><%
	Response.End

	Case CMD_HELP
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.help.asp" --><%
	Response.End

	Case CMD_RANKPOINT
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.RankingPoint.asp" --><%
	Response.End
	Case CMD_CONTESTAPPEND
		%><!-- #include virtual = "/pub/api/tennisadmin/api.PlayerMore.asp" --><%
	Response.End
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/tennisadmin/api.PlayerINPUT.asp" --><%
	Response.end
	Case CMD_RANKINGINPUT
	%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.RankingPointInput.asp" --><%
		Response.end

	Case CMD_GAMEAUTO
		%><!-- #include virtual = "/pub/api/tennisadmin/api.PlayerAuto.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/tennisadmin/api.PlayerEdit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/tennisadmin/api.PlayerEditok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/tennisadmin/api.PlayerDel.asp" --><%
	Response.end
	Case CMD_FINDPLAYER
		%><!-- #include virtual = "/pub/api/tennisadmin/api.PlayerFind.asp" --><%
	Response.end
    Case CMD_PROCESSRESULT
        %><!-- #include virtual = "/pub/api/tennisadmin/gameresult/api.gameResult.asp" --><%
    Response.end
	End select

%>
