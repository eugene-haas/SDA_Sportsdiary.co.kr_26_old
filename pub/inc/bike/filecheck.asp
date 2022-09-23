<%
	'######################
			Select Case pagename
			Case "login.asp"
				If ck_id <> ""  Then
					'Response.redirect "./klist.asp"
					'Response.end
				 End If
			Case else
				If ck_id = ""  Then
					'Response.redirect "./login.asp"
					'Response.end
				 End If
			End Select
	 '#####################
%>