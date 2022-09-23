<!-- #include virtual = "/pub/header.bike.asp" -->
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
		'REQ = "{""CMD"":40003,""IDX"":""135"",""TIDX"":""23"",""SGB"":""트랙"",""SGBSUB"":""개인경기"",""SGBDETAIL"":""경륜경기"",""GameS"":""2018-07-01"",""SOLOCNT"":""20"",""GAMECNT"":""2"",""MEMBERSEX"":""man"",""DEPARTMENT"":""남자부""}"
'		REQ = "{""CMD"":40002,""IDX"":""128""}"
        REQ = " {""CMD"":30026,""GB"":""로드"",""GBSUB"":""개인경기"",""GBDETAIL"":""테스트""} "
	Else
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
	CMD_INSERTGB = 30023 '대분류생성
	CMD_W = 40001	'등록
	CMD_SELECTGB = 30022 '대분류검색

	CMD_INSERTSUBGB = 30024 '중분류생성
	CMD_SELECTSUBGB = 30025 '중분류검색
	CMD_INSERTDETAILGB = 30026	'경기종류생성

	CMD_GAMEHOST = 30036 '주최생성
	CMD_GAMEORGN = 30038 '주관생성
	CMD_SETBOODATE = 30040  '날짜추가


	CMD_E = 40002	'수정불러오기
	CMD_EOK = 40003 '수정완료
	CMD_D = 40004	'삭제

	CMD_SELECTSIDO = 50001	'시도로 구군검색
	CMD_SELECTGB2 = 50002	'대분류검색
	Select Case CDbl(CMD)


	Case CMD_INSERTGB,CMD_SELECTGB
		%><!-- #include virtual = "/pub/api/bike/contestlevel/api.insertGb.asp" --><%
	Response.End
	Case CMD_INSERTSUBGB,	CMD_SELECTSUBGB
		%><!-- #include virtual = "/pub/api/bike/contestlevel/api.insertSubGb.asp" --><%
	Response.End
	Case CMD_INSERTDETAILGB
		%><!-- #include virtual = "/pub/api/bike/contestlevel/api.insertDetailGb.asp" --><%
	Response.End


	Case CMD_W
		%><!-- #include virtual = "/pub/api/bike/contestlevel/api.write.asp" --><%
	Response.End



	Case CMD_D
		%><!-- #include virtual = "/pub/api/bike/contestlevel/api.del.asp" --><%
	Response.End

	Case CMD_EOK
		%><!-- #include virtual = "/pub/api/bike/contestlevel/api.editok.asp" --><%
	Response.End

	Case CMD_E
		%><!-- #include virtual = "/pub/api/bike/contestlevel/api.edit.asp" --><%
	Response.End



	Case CMD_SETBOODATE
		%><!-- #include virtual = "/pub/api/ksports/api.setboodate.asp" --><%
	Response.End

	Case CMD_GAMEHOST,CMD_GAMEORGN
		%><!-- #include virtual = "/pub/api/ksports/api.insertSelect.asp" --><%
	Response.End




	Case CMD_SELECTSIDO
		%><!-- #include virtual = "/pub/api/ksports/api.SidoGb.asp" --><%
	Response.End

	Case CMD_SELECTGB2
		%><!-- #include virtual = "/pub/api/ksports/api.selectGb.asp" --><%
	Response.End

	End select
%>
