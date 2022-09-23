<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->
<%
SET ajaxDb = Server.CreateObject("ADODB.Connection")
    ajaxDb.CommandTimeout = 1000
    ajaxDb.Open B_ConStr
Dim req
req = fInject(request("req"))

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  paymentIdx    = oJSONoutput.paymentIdx
End If

SQL =       " SELECT PaymentAccount, Price, TitleName, UserName, UserPhone FROM tblBikePayment a "
SQL = SQL & " LEFT JOIN tblBikeTitle b ON a.TitleIdx = b.TitleIdx "
SQL = SQL & " LEFT JOIN SD_Member.dbo.tblMember c ON a.MemberIdx = c.MemberIdx "
SQL = SQL & " LEFT JOIN (SELECT SUM(CONVERT(INT, Price)) Price, PaymentIdx FROM tblBikePaymentHistory GROUP BY PaymentIdx) d ON a.PaymentIdx = d.PaymentIdx "
SQL = SQL & " WHERE a.PaymentIdx = "& paymentIdx &" "
Set rs = ajaxDb.Execute(SQL)
If Not rs.eof Then
  PaymentAccount = rs("PaymentAccount")
  Price          = rs("Price")
  TitleName      = rs("TitleName")
  UserName       = rs("UserName")
  UserPhone      = rs("UserPhone")
End If

content = GetPayTextContent(TitleName, UserName, PaymentAccount, Price)
Call SendText(ajaxDb, UserPhone, TitleName, content)

strjson = JSON.Stringify(oJSONoutput)
response.write strjson
response.end

ajaxDb.dispose()
Set ajaxDb = nothing
Set oJSONoutput = nothing
%>
