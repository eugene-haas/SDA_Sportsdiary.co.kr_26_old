<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
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
		REQ ="{""CMD"":50002,""IDX"":131}"
	Else
		REQ = request("REQ")
	End if
	'REQ ="{""CMD"":30002,""IDX"":49}"

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

	CMD_WRITE = 50001 '등록
	CMD_EDIT = 50002 '내용불러오기
	CMD_EDITOK = 50003 '수정
	CMD_DEL = 50004 '삭제

	CMD_SETPOINT = 50006 '포인트창
	CMD_SETP = 455	'포인트 설정

	Select Case CDbl(CMD)

	Case CMD_SETP
		%><!-- #include virtual = "/pub/api/RidingAdmin/kind/api.setp.asp" --><%
	Response.End


	Case CMD_SETPOINT
		%><!-- #include virtual = "/pub/api/RidingAdmin/kind/api.setpoint.asp" --><%
	Response.End

	Case CMD_WRITE
		%><!-- #include virtual = "/pub/api/RidingAdmin/kind/api.kindWrite.asp" --><%
	Response.End
	Case CMD_EDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/kind/api.kindEdit.asp" --><%
	Response.End
	Case CMD_EDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/kind/api.kindEditOk.asp" --><%
	Response.End
	Case CMD_DEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/kind/api.kindDel.asp" --><%
	Response.end	

	End select
%>
