<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->
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
		REQ ="{""CMD"":40000,""TIDX"":14,""FNM"":""/RDN01/2019/notice/111[3].txt""}"
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
	CMD_EDITOR = 40000
	CMD_EDITOROK = 40001

	Select Case CDbl(CMD)
	Case CMD_EDITOR
		%><!-- #include virtual = "/pub/api/bike/board/result/api.editor.asp" --><%
	Response.End
	Case CMD_EDITOROK
		%><!-- #include virtual = "/pub/api/bike/board/result/api.editorOK.asp" --><%
	Response.End

	End select
%>
