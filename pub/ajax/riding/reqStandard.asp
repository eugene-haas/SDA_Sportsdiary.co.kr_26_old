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
		REQ = "{""CMD"":500,""IDX"":""27"",""TESTTYPE"":""1""}"
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
	End If
	


	'define CMD
	CMD_MAKE = 200	'sendform index를 포함해서. (기준관리가 있는지에 따라서 내용을 불러오거나 .수정)
	CMD_TESTTITLE = 210	'심사지명 저장
	CMD_MAKELIST = 220 '순서 항목추가.
	CMD_MAKELIST2 = 230 '순서 각과목항목추가
	CMD_DELORDER = 340 '순서삭제
	CMD_DELORDER2 = 350 '순서삭제2
	CMD_INPUT = 400 '입력값 업데이트
	CMD_NOCHANGE = 401 '순서변경
	CMD_SAVE = 500	'저장
	CMD_DEL = 501	'삭제

	Select Case CDbl(CMD)

	Case CMD_DEL
	%><!-- #include virtual = "/pub/api/RidingAdmin/management/api.del.asp" --><%
	Response.End

	Case CMD_SAVE
	%><!-- #include virtual = "/pub/api/RidingAdmin/management/api.save.asp" --><%
	Response.End
	Case CMD_NOCHANGE
	%><!-- #include virtual = "/pub/api/RidingAdmin/management/api.nochange.asp" --><%
	Response.End
	Case CMD_INPUT
	%><!-- #include virtual = "/pub/api/RidingAdmin/management/api.input.asp" --><%
	Response.End


	Case CMD_DELORDER2
	%><!-- #include virtual = "/pub/api/RidingAdmin/management/api.delorder2.asp" --><%
	Response.End
	Case CMD_DELORDER
	%><!-- #include virtual = "/pub/api/RidingAdmin/management/api.delorder.asp" --><%
	Response.End

	Case CMD_MAKE
	%><!-- #include virtual = "/pub/api/RidingAdmin/management/api.management.asp" --><%
	Response.End
	Case CMD_TESTTITLE
	%><!-- #include virtual = "/pub/api/RidingAdmin/management/api.savetitle.asp" --><%
	Response.End
	Case CMD_MAKELIST
	%><!-- #include virtual = "/pub/api/RidingAdmin/management/api.makelist.asp" --><%
	Response.End
	Case CMD_MAKELIST2
	%><!-- #include virtual = "/pub/api/RidingAdmin/management/api.makelist2.asp" --><%
	Response.End
	End Select


%>