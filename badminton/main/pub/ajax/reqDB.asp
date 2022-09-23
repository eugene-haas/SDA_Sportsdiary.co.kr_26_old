<!-- #include virtual = "/pub/header.bm.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->


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
'############################################

	If request("test") = "t" Then
		REQ = "{""TARGET"":""test2"",""TARGETOBJID"":""selectfield2_targetobj"",""TARGETDBNM"":""K_sports""}"
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
	CMD_TARGETDB = 20000 '디비 테이블 가져오기
	CMD_TARGETTABLE = 20001 '대상 테이블 셋팅 (필드)


	Select Case CDbl(CMD)
	Case CMD_TARGETDB
		%><!-- #include virtual = "/pub/api/migration/api.targetdb.asp" --><%
	Response.End	

	Case CMD_TARGETTABLE
		%><!-- #include virtual = "/pub/api/migration/api.targettable.asp" --><%
	Response.End	

	End select	

	
%>