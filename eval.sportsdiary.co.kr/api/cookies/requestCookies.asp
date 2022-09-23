
<!-- #include virtual = "/api/fn/fn.cipher.asp" --><%'암호화%>
<%
Cookies_eval = request.Cookies("EVAL2")
'#################################
'객체인지 파악하고 아니라면
'#################################
If Cookies_eval <> "" Then
	Cookies_evalDecode =  f_dec(Cookies_eval)

	If IsJsonString(Cookies_evalDecode) = false Then
			for each Item in request.cookies
					Response.cookies(item).expires	= DateAdd("d",-10000,now())		 'date - 365
					Response.cookies(item).domain		= CHKDOMAIN
			Next
			response.end
	End If

End if
'#################################


If Cookies_eval <> "" Then
	Cookies_evalDecode =  f_dec(Cookies_eval)

	Set adCookies = JSON.Parse(Cookies_evalDecode)
		Cookies_aIDX 		=	 adCookies.Get("aIDX")				'관리자키
		Cookies_aID 		=	 adCookies.Get("aID")					'아이디
		Cookies_aNM 		=	 adCookies.Get("aNM")					'이름
		Cookies_aAUTH		=	 adCookies.Get("aAUTH")				'권한
		Cookies_aGrpIDX =	 adCookies.get("aGrpIDX") 		'협단체키
		Cookies_aGrpNM 	=	 adCookies.get("aGrpNM")	
	End If

End If
%>
