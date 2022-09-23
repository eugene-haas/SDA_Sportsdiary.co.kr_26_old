<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, titleIdx, hostIdx
hostIdx    = fInject(Request("hostIdx"))
titleIdx   = fInject(Request("titleIdx"))
titleYear  = fInject(Request("titleYear"))
pageSize   = fInject(Request("pageSize"))
pageNumber = fInject(Request("pageNumber"))


If hostIdx = "" Then
  Response.End
End If

SQL = " SELECT HostCode FROM tblBikeHostCode WHERE HostIdx = "& hostIdx
Set rs = db.Execute(SQL)
If Not rs.eof Then
  hostCode = rs(0)
End If

fileRoot = "http://upload.sportsdiary.co.kr/sportsdiary/" & hostCode

If pageNumber = "" Then
  pageNumber = 1
End If

If pageSize = "" Then
  pageSize = 10
End If

SQL =       " SELECT Top "& pageSize &" * FROM ( "
' S:T2
SQL = SQL & " SELECT TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY WriteDate DESC) RowNum "
SQL = SQL & " , CEILING(CONVERT(FLOAT, ROW_NUMBER() OVER(ORDER BY WriteDate DESC)) / "& pageSize &") Page, * FROM (  "
' S:T1
SQL = SQL & " SELECT COUNT(*) OVER(PARTITION BY 1) TotalCount "
SQL = SQL & " , image.ImageIdx, image.ContentsTitle, image.OriginFile, image.Thumbnail, image.ViewCount, image.ViewOrder, image.WriteDate "
SQL = SQL & " FROM tblBikeImage image "
SQL = SQL & " INNER JOIN tblBikeTitle title ON image.TitleIdx = title.TitleIdx "
SQL = SQL & " WHERE image.DelYN = 'N' "
SQL = SQL & " AND title.DelYN = 'N' "
SQL = SQL & " AND title.hostIdx = "& hostIdx &" "
If titleIdx <> "" Then
  SQL = SQL & " AND image.TitleIdx = "& titleIdx &" "
End If
If titleYear <> "" Then
  SQL = SQL & " AND CONVERT(VARCHAR(4), title.StartDate, 121) = '"& titleYear &"' "
End If
' E:T1
SQL = SQL & " ) T1 "
SQL = SQL & " ORDER BY WriteDate DESC "
' E:T2
SQL = SQL & " ) T2 "
SQL = SQL & " WHERE RowNum BetWeen "& ((pageNumber - 1) * pageSize) + 1 &" AND "& pageNumber * pageSize &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  totalCount = rs(2)
  arrImage = rs.getRows()
Else
  totalCount = 0
End If

jsonStr = "{"
jsonStr = jsonStr & " ""totalCount"": "& totalCount &" "
jsonStr = jsonStr & ","
jsonStr = jsonStr & " ""list"": ["

If IsArray(arrImage) Then

  For i = 0 To Ubound(arrImage, 2)
    Page              = arrImage(1, i)
    ImageIdx          = arrImage(3, i)
    ContentsTitle     = arrImage(4, i)
    OriginFile        = arrImage(5, i)
    Thumbnail         = arrImage(6, i)
    Thumbnail         = fileRoot & Thumbnail
    ViewCount         = arrImage(7, i)
    ViewOrder         = arrImage(8, i)
    WriteDate         = arrImage(9, i)

    jsonStr = jsonStr & "{"
    jsonStr = jsonStr & "  ""idx"": "& ImageIdx &", ""contentsTitle"": """& ContentsTitle &""", ""originImage"": """& OriginFile &""""
    jsonStr = jsonStr & ", ""thumbnail"": """& Thumbnail &""", ""viewCount"": """& ViewCount &""", ""viewOrder"": "& ViewOrder &" "
    jsonStr = jsonStr & ", ""writeDate"": """& WriteDate &""", ""page"": "& Page &" "
    jsonStr = jsonStr & "}"

    If i < Ubound(arrImage, 2) Then
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
