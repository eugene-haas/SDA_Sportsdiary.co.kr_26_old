<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, titleIdx
titleIdx = fInject(Request("titleIdx"))

If titleIdx = "" Then
  Response.End
End If

SQL = " SELECT EventDetailType FROM tblBikeEventList WHERE TitleIdx = "& titleIdx &" GROUP BY EventDetailType "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrEvent = rs.getRows()
End If

jsonStr = "{"
jsonStr = jsonStr & " ""list"": ["
jsonStr = jsonStr & """전체"""
If IsArray(arrEvent) Then
  jsonStr = jsonStr & ","
  For i = 0 To Ubound(arrEvent, 2)
    eventType = arrEvent(0, i)
    jsonStr = jsonStr & " """& eventType &""" "
    If i < Ubound(arrEvent, 2) Then
      jsonStr = jsonStr & ","
    End If
  Next
End If
jsonStr = jsonStr & "]"

jsonStr = jsonStr & "}"
Response.ContentType = "application/json"
Response.Write jsonStr
Response.End
%>
