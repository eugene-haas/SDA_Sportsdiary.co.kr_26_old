<!-- #include virtual="/bike/TSM_Player/Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
titleIdx         = fInject(Request("titleIdx"))
memberIdx        = fInject(Request("memberIdx"))



on error resume next
SQL = " UPDATE tblBikeParentInfo SET Adress = '', AdressDetail = '', AgreeYN = 'N', ParentBirth = '' WHERE MemberIdx = "& memberIdx &" AND TitleIdx = "& titleIdx
Call db.Execute(SQL)

If err.number <> 0 Then
  jsonStr = "{""return"": false}"
Else
  jsonStr = "{""return"": true}"
End If

Response.Write jsonStr
Response.End
%>
