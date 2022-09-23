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


	Function getNextStartTime(starttime, ingsec)
			Dim ingmm,starttimearr,tt,mm,nextmm,nt,nm

			ingmm = Ceil_a(ingsec/60)
			starttimearr = Split(starttime,":")
			tt = starttimearr(0)
			mm = starttimearr(1)
			nextmm = CDbl(mm) + CDbl(ingmm)

			If CDbl(nextmm) >= 60  Then
				nt = CDbl(tt) + fix(nextmm/60)
				nm = nextmm Mod 60
				getNextStartTime = addZero(nt) & ":"& addZero(nm)
			Else
				getNextStartTime = addZero(tt) & ":"& addZero(nextmm)
			End if
	End Function

'############################################

	If request("test") = "t" Then
		'REQ ="{""CMD"":13000,""AMPM"":""am"",""LIDX"":6528,""GUBUN"":""1""}"
		REQ = "{""CMD"":700,""MIDX"":""90077"",""OKNO"":""2"",""ONOFF"":""on"",""RNDSTR"":""결승"",""SINSTR"":""한국신기록,대회타이"",""FLDNO"":""2"",""RC"":""020859"",""PIDX"":""49326""}"
	Else
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






	CMD_GETGAMELIST = 11000
	CMD_CHANGERANE = 310 '레인베정바꾸기
	CMD_SETRC = 400 '기록 저장하기
	CMD_SETRCE2 = 401 '다이빙기록 저장
	CMD_SETOUT = 410
	CMD_SETOUTE2 = 411

	CMD_ORDERLIST = 12000'계영 신청 선수
	CMD_INPUTODR = 500 '출전
	CMD_OUTODR = 501'취소

	CMD_RNDUP = 600 '본선진출 설정
	CMD_SENDRESULT = 610	'실적전송

	CMD_SETRCOK = 700 '인정 / 승인


	CMD_SETAPPYN = 630 '앱노출여부 (오전, 오후)

	CMD_SETGAMEDATE = 620 '경영제외 날짜 저장용

	CMD_SECTIONINFOLIST = 13000	'구간기록 윈도우
	CMD_DELSECTION  = 13100 '구간기록삭제
	CMD_CHANGEBOOWIN = 13200 '부번경

	CMD_SETSECTIONRC = 12 '구간기록 입력


	Select Case CDbl(CMD)

	Case CMD_SETSECTIONRC '부변경
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.setsectionrc.asp" --><%
	Response.end


	Case CMD_CHANGEBOOWIN '부변경
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.changeboowin.asp" --><%
	Response.end

	Case CMD_DELSECTION '구간 기록삭제
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.delsection.asp" --><%
	Response.end

	Case CMD_SECTIONINFOLIST '구간 기록윈도우
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.sectioninfolist.asp" --><%
	Response.end


	Case CMD_SETAPPYN
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.setOpenApp.asp" --><%
	Response.End


	Case CMD_SETGAMEDATE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.setGameDate.asp" --><%
	Response.End

	Case CMD_SETRCOK
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.setRCOK.asp" --><%
	Response.End


	Case CMD_SENDRESULT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.sendresult.asp" --><%
	Response.End

	Case CMD_RNDUP
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.setFinal.asp" --><%
	Response.End

	Case CMD_OUTODR
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.outodr.asp" --><%
	Response.End


	Case CMD_INPUTODR
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.inputodr.asp" --><%
	Response.End


	Case CMD_ORDERLIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.orderList.asp" --><%
	Response.end


	Case CMD_SETOUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.saveOut.asp" --><%
	Response.End

	Case CMD_SETOUTE2
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.saveOutE2.asp" --><%
	Response.End

	Case CMD_SETRC
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.saveRecord.asp" --><%
	Response.End

	Case CMD_SETRCE2 '다이빙
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.saveRecordE2.asp" --><%
	Response.End



	Case CMD_GETGAMELIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/inputRecord/api.gamelist.asp" --><%
	Response.End

	Case CMD_CHANGERANE
		%><!-- #include virtual = "/pub/api/swimmingAdmin/draw/api.changerane.asp" --><%
	Response.End










	End Select
%>
