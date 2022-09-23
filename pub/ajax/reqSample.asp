<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
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

	If request("test") = "t" Then
	    REQ = "{""CMD"":600,""RDNO"":2,""TIDX"":44,""GBIDX"":200,""MIDXS"":[],""KGAME"":""Y"",""ORTYPE"":""A""}" 
	else
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


	'define CMD
	CMD_JSON = 100
	CMD_HTML = 20000
	Select Case CDbl(CMD)

	case CMD_JSON
		%><!-- #include virtual = "/pub/api/api.sample.json.asp" --><%
	Response.End

	case CMD_HTML
		%><!-- #include virtual = "/pub/api/api.sample.html.asp" --><% 
	Response.End

	End Select
%>
