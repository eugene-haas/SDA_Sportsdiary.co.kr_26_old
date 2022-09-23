<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, titleIdx, hostIdx
hostIdx         = fInject(Request("hostIdx"))
titleIdx        = fInject(Request("titleIdx"))
titleYear       = fInject(Request("titleYear"))
pageSize        = fInject(Request("pageSize"))
pageNumber      = fInject(Request("pageNumber"))
searchText      = fInject(Request("searchText"))
eventDetailType = fInject(Request("eventDetailType"))
videoIdx        = fInject(Request("VideoIdx"))


If hostIdx = "" Then
  Response.End
End If

If pageNumber = "" Then
  pageNumber = 1
End If

If pageSize = "" Then
  pageSize = 10
End If

If Cdbl(pageSize) > 20 Then
  pageSize = 20
End If

SQL =       " SELECT Top "& pageSize &" * FROM ( "
' S:T2
SQL = SQL & " SELECT TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY WriteDate DESC) RowNum "
SQL = SQL & " , CEILING(CONVERT(FLOAT, ROW_NUMBER() OVER(ORDER BY WriteDate DESC)) / "& pageSize &") Page, * FROM (  "
' S:T1
SQL = SQL & " SELECT COUNT(*) OVER(PARTITION BY 1) TotalCount "
SQL = SQL & " , video.VideoIdx, video.Contents, video.ContentsThumbnail, video.ContentsTitle, title.TitleName, video.ViewCount, video.ViewOrder, video.WriteDate "
SQL = SQL & " FROM tblBikeVideo video "
SQL = SQL & " INNER JOIN tblBikeTitle title ON video.TitleIdx = title.TitleIdx "
SQL = SQL & " INNER JOIN tblBikeEventList event ON video.EventIdx = event.EventIdx "
SQL = SQL & " WHERE video.DelYN = 'N'  "
SQL = SQL & " AND video.OpenYN = 'Y'  "
SQL = SQL & " AND title.hostIdx = "& hostIdx &" "
If titleIdx <> "" Then
  SQL = SQL & " AND video.TitleIdx = "& titleIdx &" "
End If
If titleYear <> "" Then
  SQL = SQL & " AND CONVERT(VARCHAR(4), title.StartDate, 121) = '"& titleYear &"' "
End If
If eventDetailType <> "" And eventDetailType <> "전체" Then
  SQL = SQL & " AND event.EventDetailType = '"& eventDetailType &"' "
End If
If Trim(searchText) <> "" Then
  SQL = SQL & " AND video.ContentsTitle LIKE '%"& searchText &"%' "
End If
If videoIdx <> "" Then
  SQL = SQL & " AND video.VideoIdx = "& videoIdx &" "
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
  arrVideo = rs.getRows()
Else
  totalCount = 0
End If

jsonStr = "{"
jsonStr = jsonStr & " ""totalCount"": "& totalCount &" "
jsonStr = jsonStr & ","
jsonStr = jsonStr & " ""list"": ["

If IsArray(arrVideo) Then

  For i = 0 To Ubound(arrVideo, 2)
    Page              = arrVideo(1, i)
    VideoIdx          = arrVideo(3, i)
    Contents          = arrVideo(4, i)
    ContentsThumbnail = arrVideo(5, i)
    ContentsTitle     = arrVideo(6, i)
    TitleName         = arrVideo(7, i)
    ViewCount         = arrVideo(8, i)
    ViewOrder         = arrVideo(9, i)
    WriteDate         = arrVideo(10, i)

    jsonStr = jsonStr & "{"
    jsonStr = jsonStr & "  ""idx"": "& VideoIdx &", ""contentsTitle"": """& ContentsTitle &""", ""titleName"": """& titleName &""", ""link"": """& Contents &""""
    jsonStr = jsonStr & ", ""thumbnail"": """& ContentsThumbnail &""", ""viewCount"": """& ViewCount &""", ""viewOrder"": "& ViewOrder &" "
    jsonStr = jsonStr & ", ""writeDate"": """& WriteDate &""", ""Page"": "& Page &" "
    jsonStr = jsonStr & "}"

    If i < Ubound(arrVideo, 2) Then
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
