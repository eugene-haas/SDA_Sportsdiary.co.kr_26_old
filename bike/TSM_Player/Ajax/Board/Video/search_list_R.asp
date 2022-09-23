<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, titleIdx, hostIdx
hostIdx     = fInject(Request("hostIdx"))
searchText  = fInject(Request("searchText"))


If hostIdx = "" Then
  Response.End
End If

If pageNumber = "" Then
  pageNumber = 1
End If

If pageSize = "" Then
  pageSize = 10
End If

SQL =       " SELECT TOP 10 ContentsTitle FROM tblBikeVideo a "
SQL = SQL & " LEFT JOIN tblBikeTitle b ON a.TitleIdx = b.TitleIdx "
SQL = SQL & " WHERE ContentsTitle LIKE '%"& searchText &"%' "
SQL = SQL & " AND a.DelYN = 'N' AND b.HostIdx = "& hostIdx &" ORDER BY a.WriteDate DESC "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrSearchTitle = rs.getRows()
End If



jsonStr = "{"
jsonStr = jsonStr & " ""list"": ["
If  Trim(searchText) <> "" Then
  If IsArray(arrSearchTitle) Then
    For i = 0 To Ubound(arrSearchTitle, 2)
      ContentsTitle = arrSearchTitle(0, i)
      jsonStr = jsonStr & " {""contentsTitle"": """& ContentsTitle &"""}"

      If i < Ubound(arrSearchTitle, 2) Then
        jsonStr = jsonStr & ","
      End If
    Next
  End If
End If
jsonStr = jsonStr & "]"



jsonStr = jsonStr & "}"
Response.Write jsonStr
Response.End
%>
v
