<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->
<!-- #include virtual = "/game_manager/ajax/setReq.asp" -->
<%
'#############################################
'로그인처리
'#############################################

	session.Abandon

	for each Item in request.cookies
		if item = "saveinfo" or IsNumeric(item) = true then 'popup info / login info 
			'pass
		else
			Response.cookies(item).expires	= date - 1365
			Response.cookies(item).domain	= CHKDOMAIN	
		end if
	Next

	Call oJSONoutput.Set("result", "0" ) '정상
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	Response.end
%>

