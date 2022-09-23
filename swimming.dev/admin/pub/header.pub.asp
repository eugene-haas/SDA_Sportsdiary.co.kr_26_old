<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<%
	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1
	Response.AddHeader "pragma","no-cache"
	Response.AddHeader "cache-control","private"
	Response.CacheControl = "no-cache"
%>
<!-- #include virtual = "/pub/cfg/cfg.pub.asp" -->
<!-- #include virtual = "/pub/class/db_helper.asp" -->
<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" --><%'암호화%>
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

<%'<!-- #include virtual = "/pub/fn/fn.query.pub.asp" -->%>
<%'로그#######################################%>

<%'request 후 쿠키 값 정의 순서대로 include%>
<%'<!-- #include virtual = "/pub/inc/request.ajax.pub.asp" -->%>
<!-- #include virtual = "/pub/cookies/cookies.pub.asp" -->



