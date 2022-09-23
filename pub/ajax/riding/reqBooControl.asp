<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/riding/fn.auto.merge.asp" --> 
<!-- #include virtual = "/pub/fn/fn.utiletc.asp" --> 
<!-- #include virtual = "/pub/fn/fn.log.asp" -->



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
Dim aryRDetail, aryBLimit, aryRegInfo, strRDetail, strBLimit       ' 부통합 - 부 List, 부별 인원수 

	'############################
	'마장마술 다음 시간 구하기
	'############################
	Function getNextTime(ByVal preTime, plusn)
		preTime = DATEADD("n", plusn, preTime)
		getNextTime = setTimeFormat(preTime)
	End Function



' http://tennis.sportsdiary.co.kr/pub/ajax/riding/reqboocontrol.asp?test=t
'############################################
	If request("test") = "t" Then
	'REQ = "{""CMD"":11100,""GYEAR"":""2019"",""TIDX"":""146"",""DETAIL"":""0,1,137,4,20101,706,1,1,0,0,0,0,0|0,1,137,2,20101,708,2,2,0,0,0,0,0|0,1,137,1,20101,710,3,3,0,0,0,0,0|0,1,137,1,20101,707,4,4,0,0,0,0,0|0,1,137,2,20101,709,5,5,0,0,0,0,0|0,1,137,1,20101,711,6,6,0,0,0,0,0|0,2,139,2,20102,712,1,1,0,0,0,0,0|0,2,139,0,20102,714,2,2,0,0,0,0,0|0,2,139,0,20102,716,3,3,0,0,0,0,0|0,2,139,0,20102,713,4,4,0,0,0,0,0|0,2,139,0,20102,715,5,5,0,0,0,0,0|0,2,139,0,20102,717,6,6,0,0,0,0,0|0,3,142,0,20101,718,1,1,0,0,0,0,0|0,3,142,0,20101,720,2,2,0,0,0,0,0|0,3,142,0,20101,722,3,3,0,0,0,0,0|0,3,142,0,20101,719,4,4,0,0,0,0,0|0,3,142,0,20101,721,5,5,0,0,0,0,0|0,3,142,0,20101,723,6,6,0,0,0,0,0"",""LIMIT"":""20101,3|20102,5|20103,4|20104,5|20105,4|20106,4|20107,4|20107,2""}"
	REQ = "{""CMD"":100,""IDX"":2806}"
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
	CMD_SUMBOO = 11000	'수동통합
	CMD_DIVBOO = 12000  '수동해제
    CMD_AUTOSUMBOO = 11100 '자동통합
	CMD_OKYN = 100	'성립부서 확정버튼
	CMD_SETTIMEALL = 13000  '출전순서표 전체시작시간 맞추기
	CMD_SETTIME = 200		'개별시간설정
	CMD_SETORDER = 14000	'경기별 순서생성

	CMD_SETGIVEUP = 300	'기권사유선택
	CMD_SETGIVEUPDOC = 301	'사유서제출

	CMD_SETGIVEUPR = 340	'기권사유선택 - 릴레이
	CMD_SETGIVEUPDOCR = 350	'사유서제출 -릴레이


	CMD_GAMEINPUT = 15000	'공지사항저장
	CMD_GAMEINPUT2 = 15001	'공지사항저장2

	CMD_GAMEINPUTDELSC = 410 'sc 공지 삭제 (새로고침)
	CMD_GAMEINPUTEDIT  = 15002 'sc 공지사항 내용 불러오기
	CMD_GAMEINPUTEDITOKSC = 420	'sc수정완료


	 CMD_SHOWTOURN = 16000	'토너먼트 보기


	
	CMD_CHANGEORDERNO = 330	'리그 라운드순서변경	
	CMD_CHANGENO = 320 '대진표 위치번호 변경
	CMD_LGMAKE = 70000
	CMD_TNMAKE = 777

	Select Case CDbl(CMD)

	Case CMD_LGMAKE
		%><!-- #include virtual = "/pub/api/RidingAdmin/sc/api.lgTable.asp" --><%
	Response.End
	Case CMD_TNMAKE
		%><!-- #include virtual = "/pub/api/RidingAdmin/sc/api.tnTable.asp" --><%
	Response.End
	Case CMD_CHANGEORDERNO	
		%><!-- #include virtual = "/pub/api/ridingadmin/sc/api.changeOrderno.asp" --><%
	Response.End
	Case CMD_CHANGENO
		%><!-- #include virtual = "/pub/api/ridingadmin/sc/api.changeno.asp" --><%
	Response.End




	case CMD_SHOWTOURN
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.showtourn.asp" --><% 
	Response.End


	case CMD_GAMEINPUTEDITOKSC
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.scLoadNoticeOK.asp" --><% 
	Response.End

	case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.scLoadNotice.asp" --><% 
	Response.End

	case CMD_GAMEINPUTDELSC
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.scDelNotice.asp" --><% 
	Response.End


	case CMD_GAMEINPUT2
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.scSavenotice2.asp" --><% 
	Response.End

	case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.scSavenotice.asp" --><% 
	Response.End


	case CMD_SETGIVEUP
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgiveup.asp" --><% 
	Response.End

	case CMD_SETGIVEUPDOC
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgiveupdoc.asp" --><% 
	Response.End


	case CMD_SETGIVEUPR
		%><!-- #include virtual = "/pub/api/RidingAdmin/sc/api.setgiveupR.asp" --><% 
	Response.End

	case CMD_SETGIVEUPDOCR
		%><!-- #include virtual = "/pub/api/RidingAdmin/sc/api.setgiveupdocR.asp" --><% 
	Response.End



	case CMD_SETORDER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setorder.asp" --><% 
	Response.End

	case CMD_SETTIME
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.settime.asp" --><%
	Response.End

	case CMD_SETTIMEALL
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.settimeall.asp" --><%
	Response.End

	case CMD_OKYN
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.okyn.asp" --><%
	Response.End

	case CMD_AUTOSUMBOO
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.sumboo.auto.asp" --><%
	Response.End
    
    case CMD_SUMBOO
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.sumboo.asp" --><%
	Response.End

    case CMD_DIVBOO
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.divboo.asp" --><%
	Response.End

	End Select
%>
