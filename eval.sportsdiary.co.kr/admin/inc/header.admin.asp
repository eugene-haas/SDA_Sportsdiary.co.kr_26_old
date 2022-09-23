<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<%@ codepage="65001" language="VBScript" %>
<%
	If request("EUCKR") = "Y" Then
		Response.CharSet="euc-kr"
		Session.codepage="65001"
		Response.codepage="65001"
		Response.ContentType="text/html;charset=euc-kr"
	Else
		Response.CharSet="utf-8"
		Session.codepage="65001"
		Response.codepage="65001"
		Response.ContentType="text/html;charset=utf-8"
	End If


	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1
	Response.AddHeader "pragma","no-cache"
	Response.AddHeader "cache-control","private"
	Response.CacheControl = "no-cache"
%>
<!-- #include virtual = "/api/cfg/cfg.asp" -->
<!-- #include virtual = "/api/class/db_helper.asp" -->
<!-- #include virtual = "/api/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/api/fn/fn.string.asp" -->
<!-- #include virtual = "/api/fn/fn.util.asp" -->
<!-- #include virtual = "/api/fn/fn.cipher.asp" --><%'암호화%>
<!-- #include virtual = "/api/fn/fn.evaluation.asp" -->

<!-- #include virtual="/api/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/api/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/api/class/json2.asp" -->




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
REQ = chkReqMethod("p", "POST")

If REQ <> "" Then
	Set oJSONoutput = JSON.Parse( join(array(REQ)) )

	PN = oJSONoutput.Get("PN")
	if PN = "" then
		PN = oJSONoutput.Get("pg")
	end if
	if PN = "" then
		PN = 1
	end if	

	F1 = chkStrRpl(oJSONoutput.Get("F1"),"")
	F2 = chkStrRpl(oJSONoutput.Get("F2"),"")
	F3 = chkStrRpl(oJSONoutput.Get("F3"),"")
	EvalTableIDX = chkStrRpl(oJSONoutput.Get("EvalTableIDX"),"")
	RegYear = chkStrRpl(oJSONoutput.Get("RegYear"),"")
	RTURL =	 oJSONoutput.Get("RTURL")
else
	Set oJSONoutput = JSON.Parse("{}") '없으면 페이징오류 기본값은 있게 만들자.
	PN = 1
end if
%>


<!-- #include virtual = "/api/cookies/cookies.pub.asp" -->



