<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, imageIdx, viewCount
imageIdx         = fInject(Request("imageIdx"))

If imageIdx = "" Then
  Response.End
End If

If imageIdx = 0 Then
  jsonStr = "{""return"": false}"
  Response.End
End If

on error resume next
db.BeginTrans()

SQL = " UPDATE tblBikeImage Set ViewCount = ViewCount + 1 WHERE ImageIdx = "& imageIdx &" "
Call db.Execute(SQL)

SQL = " SELECT ViewCount FROM tblBikeImage WHERE ImageIdx = "& imageIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  viewCount = rs(0)
End If

If err.number <> 0 Then
  db.RollbackTrans()
  jsonStr = "{""return"": false}"
Else
  db.CommitTrans()
  jsonStr = "{""return"": true, ""viewCount"": "& viewCount &"}"
End If

db.dispose()
Set db = nothing
Set rs = nothing

Response.Write jsonStr
Response.End
%>
