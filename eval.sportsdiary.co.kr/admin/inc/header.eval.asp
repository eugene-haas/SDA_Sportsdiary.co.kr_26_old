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
'#관라자와 홈 기타등등 구분#################
SITECODE = "EVAL2" '디비자리수 5
COOKIENM = SITECODE  '생성되는 쿠키명
'##########################################

JsonData = RequestJsonObject(request)
Set oJSONoutput = JSON.Parse( join(array(JsonData)) )

%>
<!-- #include virtual = "/api/cookies/cookies.pub.asp" -->



