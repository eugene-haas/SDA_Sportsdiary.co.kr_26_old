<!--#include file="../Library/ajax_config.asp"-->
<%
    '========================================================================================
    '푸시관련 기기식별자등록 후 쿠키설정합니다.    
    '========================================================================================
    
    IF decode(request.Cookies("RegIdentityGb"), 0) <> "Y" Then 
     
        response.Cookies("RegIdentityGb").Domain = ".sportsdiary.co.kr"
        response.Cookies("RegIdentityGb").Path = "/"
        response.Cookies("RegIdentityGb").Expires = Date() + 365
        response.Cookies("RegIdentityGb") = encode("Y", 0)                    
        
        response.Write "TRUE"        

    Else
        response.Write "FALSE"
    End IF
%>
