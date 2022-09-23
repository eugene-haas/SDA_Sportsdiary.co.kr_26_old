<!-- #include file="../../Library/header.bike.asp" -->

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

SQL = " SELECT EventType FROM tblBikeEventList WHERE DelYN = 'N' AND TitleIdx = "& titleIdx &" GROUP BY EventType ORDER BY EventType DESC "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrEventType = rs.getRows()
End If

' 기본정보
SQL =       " SELECT TitleIdx, TitleName, StartDate, EndDate, ApplyStart, ApplyEnd, ApplyOpenYN "
SQL = SQL & " , CalendarOpenYN, MatchTableOpenYN, Summary, TitleRule, EventRule, MatchTable, Result, b.SidoNm, a.tableimg,a.resultimg  "
SQL = SQL & " FROM tblBikeTitle a "
SQL = SQL & " LEFT JOIN tblSidoInfo b ON a.Sido = b.Sido "
SQL = SQL & " WHERE a.TitleIdx = "& titleIdx &" AND a.DelYN = 'N' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  TitleIdx          = rs("TitleIdx")
  TitleName         = rs("TitleName")
  StartDate         = rs("StartDate")
  EndDate           = rs("EndDate")
  ApplyStart        = rs("ApplyStart")
  ApplyEnd          = rs("ApplyEnd")
  ApplyOpenYN       = rs("ApplyOpenYN")
  CalendarOpenYN    = rs("CalendarOpenYN")
  MatchTableOpenYN  = rs("MatchTableOpenYN")
  Summary           = rs("Summary")
  TitleRule         = rs("TitleRule")
  EventRule         = rs("EventRule")
  MatchTable        = rs("MatchTable")
  Result            = rs("Result")
  Sido              = rs("SidoNm")
  tableimg		= rs("tableimg")
  resultimg		= rs("resultimg")

  eventTypeJson = """eventTypeList"": "
  eventTypeJson = eventTypeJson & "["
  If IsArray(arrEventType) Then
    For i = 0 To Ubound(arrEventType, 2)
      eType = arrEventType(0, i)
      eventTypeJson = eventTypeJson & "{""eType"": """& eType &"""}"
      If i < Ubound(arrEventType, 2) Then
        eventTypeJson = eventTypeJson & ","
      End If
    Next
  End If
  eventTypeJson = eventTypeJson & "]"

  jsonStr = jsonStr & """titleIdx"": """& TitleIdx &""", ""title"": """& TitleName &""", ""startDate"": """& StartDate &""", ""endDate"": """& EndDate &""" "
  jsonStr = jsonStr & ", ""applyStart"": """& ApplyStart &""", ""applyEnd"": """& ApplyEnd &""", ""applyOpen"": """& ApplyOpenYN &""", ""calendarOpen"": """& CalendarOpenYN &""" "
  jsonStr = jsonStr & ", ""matchTableOpen"": """& MatchTableOpenYN &""", ""summary"": """& Summary &""", ""titleRule"": """& TitleRule &""", ""eventRule"": """& EventRule &""" "
  jsonStr = jsonStr & ", ""matchTable"": """& MatchTable &""", ""result"": """& Result &""", "& eventTypeJson &", ""place"": """& Sido &""" "


  jsonStr = jsonStr & ", ""tableimg"": """& tableimg &""", ""resultimg"": """& resultimg &"""  "
End If

jsonStr = jsonStr & "}"

Response.ContentType = "application/json"
Response.Write jsonStr
Response.End
%>
