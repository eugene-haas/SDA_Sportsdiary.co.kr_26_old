<!-- #include file="../../Library/header.bike.asp" -->

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

' parentInfoIdx  = 41
' memberIdx  = 15942
' titleIdx  = 3
If parentInfoIdx = "" Or memberIdx = "" Then
  Response.End
Else
  p = encode(parentInfoIdx & "," & memberIdx & "," & titleIdx, 0)
End If



' 문자보낼 정보세팅
SQL = " SELECT UserName FROM SD_Member.dbo.tblMember WHERE MemberIdx = "& memberIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  userName = rs(0)
  Set rs = nothing
End If
kind        = "parentAgree"
sendTitle   = "보호자 동의 문자"
pageLink    = "http://bike.sportsdiary.co.kr/bike/event/pagree.asp?p="& p &" "
sendContent = GetTextContent(db, kind, pageLink, titleIdx, userName)

SQL = " SELECT ParentPhone FROM tblBikeParentInfo WHERE MemberIdx = '"& memberIdx &"' AND ParentInfoIdx = "& parentInfoIdx &" AND DelYN = 'N' AND AgreeYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  parentPhone = rs(0)
  parentPhone = replace(parentPhone, "-", "")
End If

on error resume next
db.BeginTrans()

Call SendText(db, parentPhone, sendTitle, sendContent)

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

Response.Write jsonStr
Response.End
%>
