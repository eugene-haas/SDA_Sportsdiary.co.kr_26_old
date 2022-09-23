<%
    Response.Expires = -1
    Response.ExpiresAbsolute = now() - 1
    Response.ContentType = "text/html;charset=utf-8"
    Response.CacheControl = "no-cache"
    Response.CacheControl = "private"
    Response.CodePage = "65001"
    Session.codepage = "65001"
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
    Sub DELAY(valTime)

		dim SecCount : SecCount = 0
		dim Sec2 : Sec2 = 0
		dim Sec1

		While SecCount < valTime + 1
			Sec1 = Second(Time())

			IF Sec1 <> Sec2 Then 
				Sec2 = Second(Time())
				SecCount = SecCount + 1
                
                response.write "SecCount="&SecCount-1&"<br>"
			END IF
    
            
		Wend 

	End Sub 

	DELAY(5)
%>
</body>
</html>