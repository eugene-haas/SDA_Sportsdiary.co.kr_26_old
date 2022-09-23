<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
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
		REQ = "{""CMD"":300,""ridx"":"""",""tidx"":""25"",""teamgb"":"""",""teamgbNm"":"""",""levelno"":""20104001"",""levelNm"":"""",""p1boono"":""20105"",""p2boono"":""20105"",""attname"":""백승훈"",""attphone"":""01047093654"",""attpwd"":""0000"",""attask"":"""",""inbankdate"":""2019-05-3"",""inbankname"":""백승훈"",""p1idx"":""6741"",""p1name"":""백승훈"",""p1grade"":"""",""p1phone"":""01047093654"",""p1team1"":""ATE0003749"",""p1team1txt"":""우리끼리"",""p1team2"":"""",""p1team2txt"":"""",""p2idx"":"""",""p2name"":"""",""p2grade"":"""",""p2phone"":""010"",""p2team1"":"""",""p2team1txt"":"""",""p2team2"":"""",""p2team2txt"":""""}"


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
    CMD_FIND_player_Name  = 102 '유저 검색
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

    CMD_player_bbsEditor = 40001 '선수정보 수정 요청 팝업
    CMD_player_bbsEditorOK = 40002 '선수정보 수정 저장 

    CMD_LMS_SEND = 50000 '참가신청완료 및 문자 발송
    CMD_LMS_SEND_OK = 50001 '참가신청완료 및 문자 발송 완료

    CMD_Search_game = 70000 ' // 셀렉트 박스 대회 조회
    CMD_Search_level = 70001 ' // 셀렉트 박스 부 조회

	CMD_PHONECHK = 401 '폰번호 중복체크

	Select Case CDbl(CMD)

	Case CMD_PHONECHK
		%><!-- #include virtual = "/pub/api/mobile/api.phoneNoCheck.asp" --><%
	Response.end

	Case CMD_Search_game
        %><!-- #include virtual = "/pub/api/mobile/api.searchGame.asp" --><%
	Response.End
	Case CMD_Search_level
        %><!-- #include virtual = "/pub/api/mobile/api.searchLevel.asp" --><%
	Response.End

	Case CMD_LMS_SEND
        %><!-- #include virtual = "/pub/api/mobile/api.sendSms.asp" --><%
	Response.End

	Case CMD_PLAYERDEL
		%><!-- #include virtual = "/pub/api/mobile/api.playerDel.asp" --><%
	Response.End

	Case CMD_player_bbsEditor
		%><!-- #include virtual = "/pub/api/mobile/api.bbsEditor.asp" --><%
	Response.End
	Case CMD_player_bbsEditorOK
		%><!-- #include virtual = "/pub/api/mobile/api.bbsEditorOK.asp" --><%
	Response.End

	Case CMD_EDITOR
		%><!-- #include virtual = "/pub/api/mobile/api.editor.asp" --><%
	Response.End

	Case CMD_Request_Edit_s1
		%><!-- #include virtual = "/pub/api/mobile/api.Request_Edit_s1.asp" --><%
	Response.End
	Case CMD_Request_Edit_s
		%><!-- #include virtual = "/pub/api/mobile/api.Request_Edit_s.asp" --><%
	Response.End

	Case CMD_PLAYER_Pwd_ok
		%><!-- #include virtual = "/pub/api/mobile/api.RequestPwdCheck.asp" --><%
	Response.End
	Case CMD_PLAYER_Pwd_check
		%><!-- #include virtual = "/pub/api/mobile/api.RequestPwdCheck.asp" --><%
	Response.End

	Case CMD_CONTESTAPPEND
		%><!-- #include virtual = "/pub/api/mobile/api.RequestMorePlayer.asp" --><%
	Response.End
	Case CMD_CONTESTAPPENDAdd
		%><!-- #include virtual = "/pub/api/mobile/api.RequestMorePlayer.asp" --><%
	Response.End

	Case CMD_PLAYSEARCH
		%><!-- #include virtual = "/pub/api/mobile/api.searchPlayer.asp" --><%
	Response.End

	Case CMD_FIND_player_Name
		%><!-- #include virtual = "/pub/api/mobile/api.searchPlayer_find.asp" --><%
	Response.End

	Case CMD_TeamSEARCH
		%><!-- #include virtual = "/pub/api/tennisadmin/api.searchTeam.asp" --><%
	Response.End

	Case CMD_PLAYERFIND
		%><!-- #include virtual = "/pub/api/mobile/api.playerFind.asp" --><%
	Response.End

	Case CMD_PLAYERUDATE
		%><!-- #include virtual = "/pub/api/mobile/api.apply.asp" --><%
	Response.End
	Case CMD_PLAYERREG

'If USER_IP = "118.33.86.240" then
		%><%'<!-- #include virtual = "/pub/api/mobile/api.apply_test.asp" -->%><%	
'else
		%><!-- #include virtual = "/pub/api/mobile/api.apply.asp" --><%	
'End if
	Response.End


	End Select





%>
