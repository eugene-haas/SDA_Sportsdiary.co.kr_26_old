<!-- #include virtual = "/pub/header.riding.asp" -->

<%'api.searchPlayer_find.asp 에서 사용%>
<%'api.searchPlayer_find.asp 에서 사용%>



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
		'REQ = "{""CMD"":102,""SVAL"":""오충"",""tidx"":""119"",""levelno"":""20104009""}"


		REQ = "{""CMD"":50000,""tidx"":""125"",""tidxNm"":""위드라인대회"",""TeamGb"":"""",""TeamGbNm"":"""",""levelno"":""20104013"",""levelNm"":"""",""ridx"":""37235"",""ph1"":""01047093650"",""ph1nm"":""백승훈"",""ph1bnm"":""백승훈"",""ph2"":""01047093650"",""ph2idx"":""27"",""ph2nm"":""백승훈"",""ph2tnm"":""청정유성"",""ph2t2nm"":"""",""ph3"":""01036499693"",""ph3idx"":""32"",""ph3nm"":""오충선"",""ph3tnm"":""강남오픈"",""ph3t2nm"":""한가람"",""phPhone"":""01036499693"",""phI"":3,""phI_seq"":2}"

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
	CMD_PLAYSEARCH	    = 100 '유저 검색
	CMD_PLAYERFIND		= 101 '검색된 유저 정보 가져올때
    CMD_FIND_player_Name  = 103 '유저 검색
    CMD_TeamSEARCH      = 200 '팀 검색
	CMD_PLAYERREG		= 300 '참가신청 등록
    CMD_PLAYERUDATE     = 301 '참가신청 수정
	CMD_PLAYERDEL		= 400 '참가신청 취소

    CMD_PLAYER_Pwd_check = 500 '//'패스워드 체크    api.RequestPwdCheck.asp
    CMD_PLAYER_Pwd_ok   = 501 '//'패스워드 체크 성공시 페이지 이동

    CMD_CONTESTAPPEND   = 30000 '참가내역조회
    CMD_CONTESTAPPENDAdd   = 30001'참가내역조회

    CMD_Request_Edit_s = 30002 '//'참가신청내역 상세 조회
    CMD_Request_Edit_s1 = 30003 '//'참가신청내역 상세 조회

    CMD_EDITOR = 40000 '모집요강 조회

    CMD_player_bbsEditor = 40001 //'선수정보 수정 요청 팝업
    CMD_player_bbsEditorOK = 40002 //'선수정보 수정 저장

    CMD_LMS_SEND = 50000 '참가신청완료 및 문자 발송
    CMD_LMS_SEND_OK = 50001 '참가신청완료 및 문자 발송 완료

    CMD_Search_game = 70000 ' // 셀렉트 박스 대회 조회
    CMD_Search_level = 70001 ' // 셀렉트 박스 부 조회

	CMD_PHONECHK = 401 '폰번호 중복체크

	CMD_SELECTSIDO = 60001 '시도검색
	CMD_LEVELCHK = 60002	'레벨선택

	CMD_MEMBERSEARCH = 102 '통합계정검색

	Select Case CDbl(CMD)


	Case CMD_LEVELCHK
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.levelchk.asp" --><%
	Response.end

	Case CMD_SELECTSIDO
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.sidoGb.asp" --><%
	Response.end

	Case CMD_PHONECHK
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.phoneNoCheck.asp" --><%
	Response.end

	Case CMD_Search_game
        %><!-- #include virtual = "/pub/api/Riding/mobile/api.searchGame.asp" --><%
	Response.End
	Case CMD_Search_level
        %><!-- #include virtual = "/pub/api/Riding/mobile/api.searchLevel.asp" --><%
	Response.End

	Case CMD_LMS_SEND
        %><!-- #include virtual = "/pub/api/Riding/mobile/api.sendSms.asp" --><%
	Response.End

	Case CMD_PLAYERDEL
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.playerDel.asp" --><%
	Response.End

	Case CMD_player_bbsEditor
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.bbsEditor.asp" --><%
	Response.End
	Case CMD_player_bbsEditorOK
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.bbsEditorOK.asp" --><%
	Response.End

	Case CMD_EDITOR
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.editor.asp" --><%
	Response.End

	Case CMD_Request_Edit_s1
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.Request_Edit_s1.asp" --><%
	Response.End
	Case CMD_Request_Edit_s
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.Request_Edit_s.asp" --><%
	Response.End

	Case CMD_PLAYER_Pwd_ok
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.RequestPwdCheck.asp" --><%
	Response.End
	Case CMD_PLAYER_Pwd_check
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.RequestPwdCheck.asp" --><%
	Response.End

	Case CMD_CONTESTAPPEND
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.RequestMorePlayer.asp" --><%
	Response.End
	Case CMD_CONTESTAPPENDAdd
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.RequestMorePlayer.asp" --><%
	Response.End

	Case CMD_PLAYSEARCH
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.searchPlayer.asp" --><%
	Response.End

	Case CMD_MEMBERSEARCH
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.searchMember.asp" --><%
	Response.End


	Case CMD_FIND_player_Name
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.searchPlayer_find.asp" --><%
	Response.End

	Case CMD_TeamSEARCH
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchTeam.asp" --><%
	Response.End

	Case CMD_PLAYERFIND
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.playerFind.asp" --><%
	Response.End

	Case CMD_PLAYERUDATE
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.apply.asp" --><%
	Response.End
	Case CMD_PLAYERREG
		%><!-- #include virtual = "/pub/api/Riding/mobile/api.apply.asp" --><%
	Response.End

	End Select
%>
