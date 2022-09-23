<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->





<%
'https://www.smarterasp.net/support/kb/a180/how-to-send-mail-using-cdo.aspx

set objMessage = createobject("cdo.message") 
set objConfig = createobject("cdo.configuration") 
Set Flds = objConfig.Fields 
 
Flds.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 
Flds.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") ="mail.yourdomain.com" 
 
' ' Passing SMTP authentication 
Flds.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1 'basic (clear-text) authentication 
Flds.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") ="postmaster@yourdomain.com" 
''IMPORTANT: This must be same as your smtp authentication address.

Flds.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") ="password" 
 
Flds.update 
Set objMessage.Configuration = objConfig 
objMessage.To = "postmaster@yourdomain.com" 
objMessage.From = "postmaster@yourdomain.com"   ''IMPORTANT: This must be same as your smtp authentication address.
objMessage.Subject = "New Task" 
objMessage.fields.update 
objMessage.HTMLBody = "This is a test sent from CDO using smtp authentication." 
objMessage.Send 
%> 