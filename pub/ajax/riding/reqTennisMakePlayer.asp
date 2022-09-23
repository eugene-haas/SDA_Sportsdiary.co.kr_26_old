<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->




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
		REQ = "{""CMD"":30008,""findTYPE"":""s_name"",""findSEX"":""0"",""fndSTR"":""오충선"",""PAGENO"":1}"
'		REQ = "{""CMD"":30011,""IDX"":3807,""NAME"":""양환욱""}"
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
	CMD_SETSTATE = 120 '상태변경 (박탈, 해제)


	CMD_CONTESTAPPEND = 30000
	CMD_GAMEINPUT = 30001
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 30003
	CMD_GAMEINPUTDEL = 30004
	CMD_FINDPLAYER = 30008

	CMD_RANKINGINPUT = 30010





	CMD_DELOK = 201 '작업완료
	CMD_RNKBOO = 202 '랭킹부

	CMD_PLAYEREDITOK = 50001 '선수정보수정, 대회신청자 정보수정









    CMD_PROCESSRESULT = 40013 '부별 대회결과처리 화면

	CMD_MEMBERWINDOW = 60000 '회원검색팝업
	CMD_FINDMEMBER = 60001 '회원검색후 리스트 표시

	Select Case CDbl(CMD)





	Case CMD_SETSTATE
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameplayer/api.setState.asp" --><%
	Response.End


	Case CMD_MEMBERWINDOW
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameplayer/api.memberwindow.asp" --><%
	Response.End





	Case CMD_RNKBOO
		%><!-- #include virtual = "/pub/api/RidingAdmin/gameplayer/api.rankboo.asp" --><%
	Response.end

	Case CMD_PLAYEREDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.rankPlayerEdit.asp" --><%
	Response.end

	Case CMD_CONTESTAPPEND
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerMore.asp" --><%
	Response.End
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerINPUT.asp" --><%
	Response.end
	Case CMD_RANKINGINPUT
	%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.RankingPointInput.asp" --><%
		Response.end

	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerEdit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerEditok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerDel.asp" --><%
	Response.end
	Case CMD_FINDPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerFind.asp" --><%
	Response.end
    Case CMD_PROCESSRESULT
        %><!-- #include virtual = "/pub/api/RidingAdmin/gameresult/api.gameResult.asp" --><%
    Response.end
	End select

%>
