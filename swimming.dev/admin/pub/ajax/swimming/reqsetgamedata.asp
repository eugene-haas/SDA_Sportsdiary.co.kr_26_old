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
		REQ ="{""CMD"":200,""TIDX"":116}" 
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




	CMD_INSERTTEMP = 200 '참가 temp디비밀어두고 , 종목생성하기
	CMD_INSERTMEMBER = 300 '참가신청밀어넣기
	CMD_FILEFORM = 12000'업로드폼
	CMD_RESETDATA = 400 '삭제

	CMD_INSERTTEMPA = 201 '동호인
	CMD_INSERTMEMBERA = 301 '동호인

	Select Case CDbl(CMD)

	Case CMD_FILEFORM '1 업로드
		%><!-- #include virtual = "/pub/api/swimmingAdmin/setdata/api.uploadform.asp" --><%
	Response.end	

	Case CMD_INSERTTEMP '2 기본설정
		%><!-- #include virtual = "/pub/api/swimmingAdmin/setdata/api.insertTemp.asp" --><%
	Response.End
	Case CMD_INSERTTEMPA '2 기본설정(생활체육)
		%><!-- #include virtual = "/pub/api/swimmingAdmin/setdata/api.insertTempA.asp" --><%
	Response.End

	

	
	Case CMD_INSERTMEMBER '3 참가신청밀어넣기
		%><!-- #include virtual = "/pub/api/swimmingAdmin/setdata/api.insertmember.asp" --><%
	Response.End
	Case CMD_INSERTMEMBERA '3 참가신청밀어넣기(생활체육)
		%><!-- #include virtual = "/pub/api/swimmingAdmin/setdata/api.insertmemberA.asp" --><%
	Response.End



	Case CMD_RESETDATA '삭제
		%><!-- #include virtual = "/pub/api/swimmingAdmin/setdata/api.resetdata.asp" --><%
	Response.end	

	
	End Select
%>
