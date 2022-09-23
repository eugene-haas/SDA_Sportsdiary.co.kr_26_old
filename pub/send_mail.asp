<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<%@ codepage="65001" language="VBScript" %>
<%
	If request("EUCKR") = "Y" Then
		Response.CharSet="euc-kr"
		Session.codepage="65001"
		Response.codepage="65001"
		Response.ContentType="text/html;charset=euc-kr"
	Else
		Response.CharSet="utf-8"
		Session.codepage="65001"
		Response.codepage="65001"
		Response.ContentType="text/html;charset=utf-8"
	End If

	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1
	Response.AddHeader "pragma","no-cache"
	Response.AddHeader "cache-control","private"
	Response.CacheControl = "no-cache"


	Set Smtp = Server.CreateObject("TABSUpload4.Smtp")

	email	 = request("get_j_email")	
	code	 = request("get_j_email_code")	

	strContent = "http://b2b.samsungbizmall.com 에서 전송한 인증코드 입니다."
	strContent = strContent & "안녕하세요 삼성전자 B2B몰 운영대행사 위드라인입니다. "
	strContent = strContent & "인증코드 : " & code  & " 입니다." 


	Smtp.ServerName = "mail.sportsdiary.co.kr"
	Smtp.ServerPort = 25
	Smtp.AddHeader "X-TABS-Campaign", "63E3F849-267F-4B6B-BC6E-496295D789B3"
	Smtp.FromAddress = "online@widline.co.kr"
	Smtp.AddToAddr email, ""
	Smtp.Subject = "http://b2b.samsungbizmall.com 에서 전송한 인증코드 입니다.."
	Smtp.Encoding = "base64"
	Smtp.Charset = "euc-kr"
	Smtp.BodyHtml = strContent

	Set Result = Smtp.Send()
	If Result.Type = SmtpErrorSuccess Then
		Response.Write "메일이 올바르게 전달되었습니다.<p>"
	Else
		Response.Write "오류 종류:" & Result.Type & "<br>"
		Response.Write "오류 코드:" & Result.Code & "<br>"
		Response.Write "오류 설명:" & Result.Description
	End If

%>