<!-- #include file="../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, hostIdx, titleIdx
hostIdx  = fInject(Request("hostIdx"))
titleIdx = fInject(Request("titleIdx"))
titleYear = fInject(Request("titleYear"))

If hostIdx = "" Then
  Response.End
End If

' 대회가 있는 년도 리스트
SQL =        " SELECT TitleYear FROM ( "
SQL = SQL &  " SELECT CONVERT(VARCHAR(4), StartDate, 121) TitleYear, TitleIdx  "
SQL = SQL &  " FROM tblBikeTitle "
SQL = SQL &  " WHERE DelYN = 'N' "
SQL = SQL &  " AND HostIdx = "& hostIdx &" "
SQL = SQL &  " ) T1 "
SQL = SQL &  " GROUP BY TitleYear "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrTitleYear = rs.getRows()
End If

If titleYear <> "" Then
  thisYear = titleYear
Else
  thisYear = DatePart("yyyy", Date)
End If


' titleIdx 를 보내면 해당대회년도 찾아서 그년도 대회 리스트 불러온다.
If titleIdx <> "" Then
  SQL = " SELECT CONVERT(VARCHAR(4), StartDate, 121) TitleYear FROM tblBikeTitle WHERE TitleIDx = "& titleIdx &" AND DelYN = 'N' "
  Set rs = db.Execute(SQL)
  If Not rs.eof Then
    selectedTitleYear = rs(0)
  End If
End If

' 대회리스트
SQL =       " SELECT TitleIdx, TitleName FROM tblBikeTitle "
SQL = SQL & " WHERE DelYN = 'N' "
If selectedTitleYear <> "" Then
  SQL = SQL & " AND CONVERT(VARCHAR(4), StartDate, 121) = '"& selectedTitleYear &"' "
Else
  SQL = SQL & " AND CONVERT(VARCHAR(4), StartDate, 121) = '"& thisYear &"' "
End If

Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrTitle = rs.getRows()
End If


jsonStr = "{"

If IsArray(arrTitleYear) Then
  jsonStr = jsonStr & " ""year"": ["
  For i = 0 To Ubound(arrTitleYear, 2)
    titleYear = arrTitleYear(0, i)
    jsonStr = jsonStr & titleYear
    If i < Ubound(arrTitleYear, 2) Then
      jsonStr = jsonStr & ","
    End If
  Next
  jsonStr = jsonStr & "]"
End If


If IsArray(arrTitle) Then
  jsonStr = jsonStr & ","
  jsonStr = jsonStr & " ""titles"": ["
  ' jsonStr = jsonStr & "{""titleIdx"": """", ""titleName"": ""전체""}"

  For i = 0 To Ubound(arrTitle, 2)
    ' jsonStr = jsonStr & ","
    TitleIdx  = arrTitle(0, i)
    TitleName = arrTitle(1, i)
    jsonStr = jsonStr & "{""titleIdx"": "& TitleIdx &", ""titleName"": """& TitleName &"""}"

    If i < Ubound(arrTitle, 2) Then
      jsonStr = jsonStr & ","
    End If
  Next
  jsonStr = jsonStr & "]"
End If



jsonStr = jsonStr & "}"
Response.ContentType = "application/json"
Response.Write jsonStr
Response.End
%>
