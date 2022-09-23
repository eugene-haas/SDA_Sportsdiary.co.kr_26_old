<!-- #include virtual = "/pub/header.tbmgr.ajax.asp" -->

<!-- #include virtual = "/pub/fnex/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fnex/fn.paging.asp" -->
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
		REQ = "{""CMD"":10004}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") > 0 then
	Set oJSONoutput = JSON.Parse(REQ)
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if

    'Response.Write("<script language=Javascript> console.log(' Call reqdbcomment.asp '); </script>")

	CMD_TABLECMT = 1
	CMD_COLUMNCMT = 2 '코멘트 인서트, 업데이트
	CMD_TABLECLUMN = 10002
	CMD_TABLELIST = 10004
	CMD_A6 = 6 '테이블 복사

	Select Case CDbl(CMD)
	Case CMD_TABLECMT
		%><!-- #include virtual = "/pub/api/system/api.tablecmt.asp" --><%
		Response.end		
	Case CMD_COLUMNCMT
		%><!-- #include virtual = "/pub/api/system/api.columncmt.asp" --><%
		Response.end	

	Case CMD_TABLECLUMN
		%><!-- #include virtual = "/pub/api/system/api.tableclumn.asp" --><%
		Response.end	

	Case CMD_TABLELIST
		%><!-- #include virtual = "/pub/api/system/api.tableList.asp" --><%
		Response.end	

	Case CMD_A6
        Response.Write("<script language=Javascript> console.log(' Call this Table copy'); </script>")
		%><!-- #include virtual = "/pub/api/system/api.copytable.asp" --><%
		Response.end	

	End select
%>