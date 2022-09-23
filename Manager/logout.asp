<%
	Response.Cookies("UserIDX")    = ""
	Response.Cookies("UserID")     = ""
	Response.Cookies("UserName")   = ""
	Response.Cookies("HandPhone")  = ""
	Response.Cookies("PartName")   = ""
	Response.Cookies("SportsName") = ""
	Response.Cookies("SportsCode") = ""
	Response.Cookies("HostCode")   = ""
%>
<script type="text/javascript">
top.location.href="/Manager/gate.asp";
</script>