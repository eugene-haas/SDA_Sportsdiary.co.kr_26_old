<% 

'Response.Write "<script>"
'Response.Write "alert('123123');"
'Response.Write "</script>"

'Response.Redirect "http://sdmain.sportsdiary.co.kr/sdmain/index.asp?AppType=" & Request("AppType")
%>

<script>

	var IsFirstAccYN = "";
	
	function beginInstall(){

	 IsFirstAccYN = "Y"

	}


	location.href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp?AppType=<%=Request("AppType")%>&IsFirstAccYN=" + IsFirstAccYN;
</script>