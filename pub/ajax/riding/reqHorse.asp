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
		REQ ="{""CMD"":500,""IDX"":8941}"
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

	CMD_GAMEINPUT = 301
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 303
	CMD_GAMEINPUTDEL = 304
	CMD_FILEFORM = 12000 '업로드
    CMD_SETYN  = 500 '신청처리


	Select Case CDbl(CMD)
	Case CMD_SETYN
		%><!-- #include virtual = "/pub/api/RidingAdmin/horse/api.setyn.asp" --><%
	Response.end

	Case CMD_FILEFORM
		%><!-- #include virtual = "/pub/api/RidingAdmin/horse/api.uploadform.asp" --><%
	Response.End
	

	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/RidingAdmin/horse/api.Input.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/horse/api.Inputedit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/horse/api.Inputeditok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/horse/api.InputDel.asp" --><%
	Response.end
	
	
	
	Response.End
	End Select
%>
