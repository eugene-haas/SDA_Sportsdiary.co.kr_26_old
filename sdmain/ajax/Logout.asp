<!--#include file="../Library/ajax_config.asp"-->
<%
   	'로그아웃
	dim CHK_COOKIESLOG : CHK_COOKIESLOG	= SET_COOKIES_LOGOUT()	'쿠키삭제처리	
	 
 
	IF CHK_COOKIESLOG = "TRUE" Then
		Session.Abandon   		
	End IF
	
	response.Write CHK_COOKIESLOG	
%>