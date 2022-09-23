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
		REQ = "{""pg"":1,""tidx"":23,""LVLIDX"":0,""ridx"":1,""groupno"":0,""name"":""참가종목선택"",""mysex"":""man"",""BOONM"":""남자부"",""subtype"":""2"",""chkgame"":""121,CAT4:"",""bikeidx"":""9"",""marriage"":""Y"",""job"":""JOB02"",""bloodtype"":""B"",""career"":""CR004"",""brand"":""BR006"",""gamegift"":""S"",""CMD"":20030,""agree"":""Y"",""adult"":""N"",""teamnm"":""oooo"",""teamlist"":""mujerk,bnbnbn,sjh12355,"",""p_nm"":""0000"",""p_phone"":""010-0000-0000"",""p_relation"":""모"",""sendcnt"":3,""lmsno"":3,""lms"":""12816,이수진,010-6787-8723^12817,최정화,010-9001-4717^*보호자*,0000,010-0000-0000^"",""gameidx"":1395,""result"":""0""}"
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



	CMD_CHKTEAM = 300 '팀명 중복 체크
	CMD_FINDPLAYER = 20010 '팀원 아이디 조회
	CMD_AGREE = 20020 '동의창불러오기

	CMD_TEAMLMS = 20100 'lms
	CMD_PLMS = 20200 '개인 보모동의 lms

	CMD_SETINFOCHANGE = 30000 '수정창부르기
	CMD_PNOCHK = 400 '인증
	CMD_PNOUPDATE = 410 '폰번호 업데이트
	CMD_ADDRUPDATE = 420 '주소 업데이트
	CMD_EMAILUPDATE = 430 '이메일 업데이트


	CMD_PSMSPOP = 40010 '보호자동의 문자발송창
	CMD_LISTPOP = 40000 '부 팝업창
	CMD_PAGREE = 20030'	부모동의 확인 체크
	CMD_PAYNAME = 20040 '입금자명 입력

	CMD_AGREEPARENT = 500	'부모동의 완료
	CMD_REQREFUND = 600		'환불요청
	CMD_FINDEM = 20050 '수정할 맴버조회
	CMD_FINDEMOK = 700 '죄회한 맴버 수정

	Select Case CDbl(CMD)

	Case CMD_FINDEMOK
		%><!-- #include virtual = "/pub/api/bike/request/api.editFindPlayerOK.asp" --><% 
	Response.End		

	Case CMD_FINDEM
		%><!-- #include virtual = "/pub/api/bike/request/api.editFindPlayer.asp" --><% 
	Response.End		


	Case CMD_REQREFUND
		%><!-- #include virtual = "/pub/api/bike/request/api.reqRefund.asp" --><% 
	Response.End		
	
	
	Case CMD_AGREEPARENT
		%><!-- #include virtual = "/pub/api/bike/request/api.agreeParent.asp" --><% 
	Response.End		



	Case CMD_PAYNAME
		%><!-- #include virtual = "/pub/api/bike/request/api.payName.asp" --><% 
	Response.End		

	Case CMD_PAGREE
		%><!-- #include virtual = "/pub/api/bike/request/api.pagreeCheck.asp" --><% 
	Response.End		
	
	
	Case CMD_LISTPOP
		%><!-- #include virtual = "/pub/api/bike/request/api.listPOP.asp" --><% 
	Response.End		
	
	Case CMD_PSMSPOP '부모동의창
		%><!-- #include virtual = "/pub/api/bike/request/api.pagreePOP.asp" --><% 
	Response.End	
	
	
	
	
	
	
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