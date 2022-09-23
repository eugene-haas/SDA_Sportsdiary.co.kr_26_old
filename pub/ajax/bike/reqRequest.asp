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
		' REQ = "{""tidx"":""23"",""subtype"":""1"",""LVLIDX"":0,""groupno"":""0"",""name"":""참가신청"",""mysex"":""man"",""BOONM"":""남자부"",""ridx"":0,""chkgame"":""116,CAT3:117,CAT3:118,CAT3:139,CAT3:"",""bikeidx"":""12"",""marriage"":""Y"",""job"":""JOB02"",""bloodtype"":""A"",""career"":""CR001"",""brand"":""BR002"",""gamegift"":""M"",""CMD"":200,""agree"":""Y"",""adult"":""N"",""teamlist"":"",,,"",""p_nm"":""kkk"",""p_phone"":""010-4709-3650"",""p_relation"":""test""}"
    REQ = "{""tidx"":""27"",""subtype"":""1"",""LVLIDX"":0,""groupno"":""0"",""name"":""참가신청"",""mysex"":""man"",""BOONM"":""남자부"",""chkgame"":""148,CAT4:"",""ridx"":0,""bikeidx"":""140"",""marriage"":""N"",""job"":""JOB14"",""bloodtype"":""B"",""career"":""CR002"",""brand"":""BR015"",""CMD"":200,""agree"":""Y"",""adult"":""Y"",""teamlist"":"",,,"",""p_nm"":""2222"",""p_phone"":""010-2946-8454"",""p_relation"":""모""}"
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
	CMD_REGGAME = 200 '참가신청저정
	CMD_AGREETEAMMEMBER = 220 '팀원동의

	CMD_PLUSMEMBER = 20000 '단체추발 추가 인원 양식 추가
	CMD_CHKTEAM = 300 '팀명 중복 체크
	CMD_FINDPLAYER = 20010 '팀원 아이디 조회
	CMD_AGREE = 20020 '동의창불러오기
	CMD_REGTEAMGAME = 210 '참가신청 단체
	CMD_TEAMLMS = 20100 'lms
	CMD_PLMS = 20200 '개인 보모동의 lms

	CMD_SETINFOCHANGE = 30000 '수정창부르기
	CMD_PNOCHK = 400 '인증
	CMD_PNOUPDATE = 410 '폰번호 업데이트
	CMD_ADDRUPDATE = 420 '주소 업데이트
	CMD_EMAILUPDATE = 430 '이메일 업데이트

	Select Case CDbl(CMD)
	Case CMD_EMAILUPDATE
		%><!-- #include virtual = "/pub/api/bike/request/api.emailUpdate.asp" --><%
	Response.End
	Case CMD_ADDRUPDATE
		%><!-- #include virtual = "/pub/api/bike/request/api.addrUpdate.asp" --><%
	Response.End

	Case CMD_PNOUPDATE
		%><!-- #include virtual = "/pub/api/bike/request/api.pnoUpdate.asp" --><%
	Response.End

	Case CMD_PNOCHK
		%><!-- #include virtual = "/pub/api/bike/request/api.pnoCheck.asp" --><%
	Response.End

	Case CMD_SETINFOCHANGE
		%><!-- #include virtual = "/pub/api/bike/request/api.changeForm.asp" --><%
	Response.End
	Case CMD_PLMS
		%><!-- #include virtual = "/pub/api/bike/request/api.pLMS.asp" --><%
	Response.End

	Case CMD_TEAMLMS
		%><!-- #include virtual = "/pub/api/bike/request/api.sendSMs.asp" --><%
	Response.End

	Case CMD_REGTEAMGAME
		%><!-- #include virtual = "/pub/api/bike/request/api.regTeamGame.asp" --><%
	Response.End

	Case CMD_REGGAME
		%><!-- #include virtual = "/pub/api/bike/request/api.regGame.asp" --><%
	Response.End
	Case CMD_AGREETEAMMEMBER
		%><!-- #include virtual = "/pub/api/bike/request/api.agreeTeamMember.asp" --><%
	Response.End



	Case CMD_PLUSMEMBER
		%><!-- #include virtual = "/pub/api/bike/request/api.plusMember.asp" --><%
	Response.End

	Case CMD_CHKTEAM
		%><!-- #include virtual = "/pub/api/bike/request/api.chkTeam.asp" --><%
	Response.End

	Case CMD_FINDPLAYER
		%><!-- #include virtual = "/pub/api/bike/request/api.findplayer.asp" --><%
	Response.End

	Case CMD_AGREE '동의창
		%><!-- #include virtual = "/pub/api/bike/request/api.agreeWindow.asp" --><%
	Response.End

	End select
%>
