<!-- #include file="../../../Library/header.bike.asp" -->

<%
Response.ContentType = "application/json"
Dim totalFee, discountFee
discountFee = 0
totalFee = 0
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

eventIdx = fInject(Request("eventIdx"))
memberIdx = fInject(Request("memberIdx"))
If eventIdx = "" Or memberIdx = "" Then
  Response.End
End If

' eventIdx = "12,13,14"
SQL = " SELECT EntryFee, GroupType, CourseLength, EventDetailType FROM tblBikeEventList WHERE eventIdx IN ("& eventIdx &") AND GroupType = '개인' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrSoloFee = rs.getRows()
End If


' SQL = " SELECT EventIdx FROM tblBikeEventList WHERE eventIdx IN ("& eventIdx &") AND GroupType = '단체' "
SQL =       " SELECT * FROM tblBikeEventList a "
SQL = SQL & " INNER JOIN tblBikeTeam b ON a.EventIdx = b.EventIdx AND b.LeaderIdx = "& memberIdx &" "
SQL = SQL & " WHERE a.EventIdx IN ("& eventIdx &") AND GroupType = '단체' "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  arrGroupEvent = rs.getRows()
End If

jsonStr = "{"
jsonStr = jsonStr & " ""eventList"": {"
jsonStr = jsonStr & " ""soloEvent"": "
jsonStr = jsonStr & "["
If IsArray(arrSoloFee) Then
  For s = 0 To Ubound(arrSoloFee, 2)
    fee             = arrSoloFee(0, s)
    groupType       = arrSoloFee(1, s)
    courseLength    = arrSoloFee(2, s)
    eventDetailType = arrSoloFee(3, s)
    totalFee = totalFee + Cdbl(fee)
    eventName = GetEventName(groupType, courseLength, eventDetailType)
    jsonStr = jsonStr & "{""name"": """& eventName &""", ""fee"": """& fee &"""  }"
    If s < Ubound(arrSoloFee, 2) Then
      jsonStr = jsonStr & ","
    End If
  Next

' 개인 여러개 신청시에만 할인 해당됨
discountFee = Cdbl(Ubound(arrSoloFee, 2)) * 10000
totalFee = totalFee - discountFee
End If

jsonStr = jsonStr & "],"

jsonStr = jsonStr & " ""groupEvent"": "
jsonStr = jsonStr & "["
If IsArray(arrGroupEvent) Then
  For g = 0 To Ubound(arrGroupEvent, 2)
    gEventIdx = arrGroupEvent(0, g)
    SQL =        " SELECT COUNT(*) FROM tblBikeEventApplyInfo  "
    SQL = SQL &  " WHERE TeamIdx = (SELECT TeamIdx FROM tblBikeEventApplyInfo WHERE MemberIdx = '"& memberIdx &"' AND DelYN = 'N' AND EventIdx = "& gEventIdx &")  "
    SQL = SQL &  " AND DelYN = 'N' "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      groupMemberCount = rs(0)
    End If

    SQL = " SELECT EntryFee, GroupType, CourseLength, EventDetailType FROM tblBikeEventList WHERE EventIdx = "& gEventIdx &" "
    Set rs = db.Execute(SQL)
    If Not rs.eof Then
      fee             = rs(0)
      groupType       = rs(1)
      courseLength    = rs(2)
      eventDetailType = rs(3)
      eventName = GetEventName(groupType, courseLength, eventDetailType)
    End If

    groupFee = Cdbl(groupMemberCount) * Cdbl(fee)
    jsonStr = jsonStr & "{""name"": """& eventName &""", ""fee"": """& groupFee &"""  }"
    If g < Ubound(arrGroupEvent, 2) Then
      jsonStr = jsonStr & ","
    End If
    totalFee = totalFee + Cdbl(groupFee)
  Next
End If
jsonStr = jsonStr & "],"
If discountFee > 0 Then
  jsonStr = jsonStr & " ""soloEventDiscount"": """& discountFee &""","
End If
jsonStr = jsonStr & " ""totalPrice"": """& totalFee &""" "

jsonStr = jsonStr & "}"
jsonStr = jsonStr & "}"

Response.Write jsonStr
Response.End
%>
