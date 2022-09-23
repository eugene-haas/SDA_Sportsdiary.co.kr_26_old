<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr
Dim jsonStr, hostIdx, memberIdx

titleIdx = fInject(Request("titleIdx"))
If titleIdx = "" Then
  Response.End
End If

jsonStr = "{"

' 기본정보
SQL =       " SELECT TitleIdx, TitleName, StartDate, EndDate, ApplyStart, ApplyEnd, ApplyOpenYN "
SQL = SQL & " , CalendarOpenYN, MatchTableOpenYN, Summary, TitleRule, EventRule, MatchTable, Result "
SQL = SQL & " FROM tblBikeTitle WHERE TitleIdx = "& titleIdx &" AND DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  TitleIdx          = rs("TitleIdx")
  jsonStr = jsonStr & """titleIdx"": """& TitleIdx &""", ""title"": """& TitleName &""", ""startDate"": """& StartDate &""", ""endDate"": """& EndDate &""" "
  jsonStr = jsonStr & ", ""applyStart"": """& ApplyStart &""", ""applyEnd"": """& ApplyEnd &""", ""applyOpen"": """& ApplyOpenYN &""", ""calendarOpen"": """& CalendarOpenYN &""" "
  jsonStr = jsonStr & ", ""matchTableOpen"": """& MatchTableOpenYN &""", ""summary"": """& Summary &""", ""titleRule"": """& TitleRule &""", ""eventRule"": """& EventRule &""" "
  jsonStr = jsonStr & ", ""matchTable"": """& MatchTable &""", ""result"": """& Result &""" "
End If

jsonStr = jsonStr & "}"

Response.ContentType = "application/json"
Response.Write jsonStr
Response.End
%>
