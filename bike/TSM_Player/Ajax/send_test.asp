<!-- #include file="../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, titleIdx, memberIdx
Dim sendTitle, sendContent

parentInfoIdx         = fInject(Request("parentInfoIdx"))
memberIdx             = fInject(Request("memberIdx"))
titleIdx              = fInject(Request("titleIdx"))

on error resume next
db.BeginTrans()

SQL = " SELECT TitleName FROM tblBikeTitle WHERE TitleIdx = "& titleIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  titleName = rs("TitleName")
End If

phoneNum = "01022427718"
sendTitle   = " 가상계좌문자 테스트 "
' sendContent = " 문자테스트 내용"
' kind = "teamInvite"
kind = "eventApply"
link = "bike.sportsdiary.co.kr"
eventIdx = 14
senderName = "자전거맨"
accountNumber = "1321313222"
depositPrice = "50000"
userName = "참가자"

title = "문자발송테스트 111"
' content = GetTextContent(db, kind, link, eventIdx, senderName)
' content = GetPayTextContent(kind, titleName, userName, accountNumber, depositPrice)
content = GetBusTextContent(titleName, busLocation, accountNumber, userName)
' content = "123"

' response.write content
' response.end
Call SendText(db, phoneNum, title, content)

If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  jsonStr = "{""return"": true}"
End If

db.dispose()
Set db = nothing
Set rs = nothing
'
Response.Write jsonStr
Response.End
%>
