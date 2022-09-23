<!-- #include virtual = "/pub/header.ksports.asp" -->
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
		' REQ = "{""CMD"":60001,""classCode"":""DS"",""regYear"":""2017"",""eventName"":""""}"
		'REQ = "{""CMD"": ""60011"",  ""eventYear"": ""2018"", ""classCode"": ""KD"", ""gameName"": """"}"
		'REQ = "{""classCode"":""KD"",""CMD"":60020}"
		REQ = "{""CMD"":30040,""BTYPE"":""x""}"
		'REQ = "{""CMD"":60004,""IDX"":16409}"
		'REQ = "{""CMD"":60003,""classCode"":""AE"",""eventYear"":""2018"",""gameCode"":""t99999999"",""gameVideo"":""hhttps://youtu.be/cN67kPoTJBo"",""gameSDate"":""2018-06-22"",""gameEDate"":""2018-06-23"",""gameAgeDistinct"":""M"",""gameAgeDistinctText"":""중등부"",""gameGroupType"":""T"",""gameGroupTypeText"":""단체"",""gameMatchType"":""L"",""gameMatchTypeText"":""리그"",""gameMemberGender"":""A"",""gameMemberGenderText"":""전체"",""gameOrder"":""1"",""gameMember"":""테스트"",""detailType"":""44""}"
		' REQ = "{""CMD"":60011,""eventYear"":""2018"",""classCode"":""BM"",""gameName"":""""}"
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
	CMD_SELECTGB = 30022 '대분류검색
	CMD_INSERTGB = 30023 '대분류생성
	CMD_INSERTSUBGB = 30024 '종목생성
	CMD_GAMEHOST = 30036 '주최생성
	CMD_GAMEORGN = 30038 '주관생성
	CMD_SETBOODATE = 30040  '날짜추가
	CMD_W = 40001	'등록
	CMD_E = 40002	'수정불러오기
	CMD_EOK = 40003 '수정완료
	CMD_D = 40004	'삭제

	CMD_SELECTSIDO = 50001	'시도로 구군검색
	CMD_SELECTGB2 = 50002	'대분류검색

	'대회영상 등록 정보
	CMD_SEARCHGAMELIST = 60001   '대회리스트 요청
	CMD_SELECTGAME = 60002   '대회선택
	CMD_INSERTGAMEVIDEO = 60003   '대회정보등록
	CMD_EDITGAMEINPUT = 60004  '대회정보 입력필드에 입력
	CMD_EDITGAMEINFO = 60005 '대회정보 수정
	CMD_DELETEGAMEINFO = 60006 '대회정보 삭제

	CMD_SEARCHGAMEVIDEO = 60011 '대회검색
	CMD_VIEWGAMEVIDEO = 60012 '대회비디오 보기

	CMD_SELECTCLASS = 60020 '종목값선택 - 세부종별 구분값가져오기
	CMD_INSERTDETAILTYPE = 60021 '세부종별 구분값 추가입력


	Response.end
	Select Case CDbl(CMD)
	Case CMD_D
		%><!-- #include virtual = "/pub/api/ksports/api.del.asp" --><%
	Response.End

	Case CMD_EOK
		%><!-- #include virtual = "/pub/api/ksports/api.editok.asp" --><%
	Response.End

	Case CMD_E
		%><!-- #include virtual = "/pub/api/ksports/api.edit.asp" --><%
	Response.End

	Case CMD_W
		%><!-- #include virtual = "/pub/api/ksports/api.write.asp" --><%
	Response.End

	Case CMD_SETBOODATE
		%><!-- #include virtual = "/pub/api/ksports/api.setboodate.asp" --><%
	Response.End

	Case CMD_GAMEHOST,CMD_GAMEORGN
		%><!-- #include virtual = "/pub/api/ksports/api.insertSelect.asp" --><%
	Response.End

	Case CMD_INSERTGB,CMD_SELECTGB
		%><!-- #include virtual = "/pub/api/ksports/api.insertGb.asp" --><%
	Response.End
	Case CMD_INSERTSUBGB
		%><!-- #include virtual = "/pub/api/ksports/api.insertSubGb.asp" --><%
	Response.End



	Case CMD_SELECTSIDO
		%><!-- #include virtual = "/pub/api/ksports/api.SidoGb.asp" --><%
	Response.End

	Case CMD_SELECTGB2
		%><!-- #include virtual = "/pub/api/ksports/api.selectGb.asp" --><%
	Response.End

	Case CMD_SEARCHGAMELIST
		%><!-- #include virtual = "/pub/api/ksports/api.searchGamelist.asp" --><%
	Response.End

	Case CMD_SELECTGAME
		%><!-- #include virtual = "/pub/api/ksports/api.selectGame.asp" --><%
	Response.End

	Case CMD_INSERTGAMEVIDEO
		%><!-- #include virtual = "/pub/api/ksports/api.insertGame.asp" --><%
	Response.End

	Case CMD_EDITGAMEINPUT
		%><!-- #include virtual = "/pub/api/ksports/api.editGameInput.asp" --><%
	Response.End

	Case CMD_EDITGAMEINFO
		%><!-- #include virtual = "/pub/api/ksports/api.editGameInfo.asp" --><%
	Response.End

	Case CMD_DELETEGAMEINFO
		%><!-- #include virtual = "/pub/api/ksports/api.deleteGameInfo.asp" --><%
	Response.End

	Case CMD_SEARCHGAMEVIDEO
		%><!-- #include virtual = "/pub/api/ksports/api.searchGameVideo.asp" --><%
	Response.End

	Case CMD_VIEWGAMEVIDEO
	%><!-- #include virtual = "/pub/api/ksports/api.viewGameVideo.asp" --><%
	Response.End

	Case CMD_SELECTCLASS
	%><!-- #include virtual = "/pub/api/ksports/api.selectClass.asp" --><%
	Response.End

	Case CMD_INSERTDETAILTYPE
	%><!-- #include virtual = "/pub/api/ksports/api.insertDetailType.asp" --><%
	Response.End

	End select
%>
