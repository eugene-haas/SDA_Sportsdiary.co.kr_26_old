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
		REQ ="{""CMD"":320,""LIDX"":7074}"
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




	CMD_SETAMPM = 100 '시작 오전 오후 날짜 지정
	CMD_INPUT = 200
	CMD_SETFLAG = 201
	CMD_GAMEINPUTDEL = 300 '리셋
	CMD_CHANGEODR = 310 '레인베정바꾸기 

	CMD_DELAMDATA = 320 '순서에서 제거 (뒤에 남은것들 시간 제설정)
	CMD_DELPMDATA = 340 '순서에서 제거 (뒤에 남은것들 시간 제설정)

	CMD_SETGAMENO  = 350
	CMD_SETJOONO  = 352
	Select Case CDbl(CMD)

	Case CMD_SETJOONO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/gameorder/api.changejoono.asp" --><%
	Response.End

	Case CMD_SETGAMENO
		%><!-- #include virtual = "/pub/api/swimmingAdmin/gameorder/api.changegameno.asp" --><%
	Response.End


	Case CMD_CHANGEODR
		%><!-- #include virtual = "/pub/api/swimmingAdmin/gameorder/api.changeOdr.asp" --><%
	Response.End

	Case CMD_DELAMDATA
		%><!-- #include virtual = "/pub/api/swimmingAdmin/gameorder/api.resetAMdata.asp" --><%
	Response.End


	Case CMD_DELPMDATA
		%><!-- #include virtual = "/pub/api/swimmingAdmin/gameorder/api.resetPMdata.asp" --><%
	Response.End


	Case CMD_SETAMPM
		%><!-- #include virtual = "/pub/api/swimmingAdmin/gameorder/api.setAMPM.asp" --><%
	Response.End

	Case CMD_INPUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/gameorder/api.input.asp" --><%
	Response.End

	Case CMD_SETFLAG
		%><!-- #include virtual = "/pub/api/swimmingAdmin/gameorder/api.setflag.asp" --><%
	Response.End


	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/swimmingAdmin/gameorder/api.reset.asp" --><%
	Response.End



	
	End Select
%>
