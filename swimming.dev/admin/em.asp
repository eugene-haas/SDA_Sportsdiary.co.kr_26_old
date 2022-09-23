<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%

  dim objMail 
  Set objMail = Server.CreateObject("CDO.Message") 

dim smtpServer, yourEmail, yourPassword
smtpServer = "smtp.sendgrid.net"
yourEmail = "@gmail.com"     'replace with a valid gmail account
yourPassword = ""   'replace with a valid password for account set in yourEmail 

sendEmailTo = "@gmail.com"




objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = smtpServer
objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 465 
objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = true
objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = yourEmail
objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = yourPassword
objMail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpconnectiontimeout") = 60 
objMail.Configuration.Fields.Update 

'7단계: 제목, 본문, 보낸사람, to etc.
objMail.From = yourEmail
objMail.To = sendEmailTo

objMail.Subject="Application Form Registration Details"
objMail.htmlBody = "This is test message"
objMail.Send   
%>