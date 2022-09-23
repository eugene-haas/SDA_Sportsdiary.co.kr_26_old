<!-- #include virtual = "/pub/header.bike.asp" -->
<%
Set ajaxDb = new clsDBHelper
Dim req, mode, titleIdx, eventIdx, eventType, courseLength
Dim eventTypeDetail, groupType, gender, playerType, eventDate

req = fInject(request("req"))
If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  mode             = oJSONoutput.mode
  titleIdx         = oJSONoutput.titleIdx
  eventType        = oJSONoutput.eventType
  groupType        = oJSONoutput.groupType
  gender           = oJSONoutput.gender
  courseLength     = oJSONoutput.courseLength
  eventDetailType  = oJSONoutput.eventDetailType
  eventDate        = oJSONoutput.eventDate
  ratingCategory   = oJSONoutput.ratingCategory
  minPlayer        = oJSONoutput.minPlayer
  maxPlayer        = oJSONoutput.maxPlayer
  memberLimit      = oJSONoutput.memberLimit
  entryFee         = oJSONoutput.entryFee

  If mode <> "insert" Then
    eventIdx = oJSONoutput.eventIdx
  End If
End If


on error resume next
If mode = "insert" Then
  insertSQL =             " INSERT INTO tblBikeEventList  "
  insertSQL = insertSQL & " (TitleIdx, EventType, GroupType, Gender, CourseLength, EventDetailType, EventDate, RatingCategory, MinPlayer, MaxPlayer, MemberLimit, EntryFee ) "
  insertSQL = insertSQL & " VALUES ("& titleIdx &", '"& eventType &"', '"& groupType &"', '"& gender &"', '"& courseLength &"', '"& eventDetailType &"', '"& eventDate &"' "
  insertSQL = insertSQL & "         ,'"& ratingCategory &"', '"& minPlayer &"', '"& maxPlayer &"', '"& memberLimit &"', '"& entryFee &"'  ) "
  Call ajaxDb.ExecSQLReturnRs(insertSQL, Null, B_ConStr)
ElseIf mode = "update" Then
  updateSQL =             " UPDATE tblBikeEventList SET EventType = '"& eventType &"', GroupType = '"& groupType &"', Gender = '"& gender &"', CourseLength = '"& courseLength &"' "
  updateSQL = updateSQL & " , EventDetailType = '"& eventDetailType &"', EventDate = '"& eventDate &"', RatingCategory = '"& ratingCategory &"', MinPlayer = '"& minPlayer &"' "
  updateSQL = updateSQL & " , MaxPlayer = '"& maxPlayer &"', MemberLimit = '"& memberLimit &"', EntryFee = '"& entryFee &"' "
  updateSQL = updateSQL & " WHERE EventIdx = "& eventIdx &" "
  Call ajaxDb.ExecSQLReturnRs(updateSQL, Null, B_ConStr)
ElseIf mode = "delete" Then
  deleteSQL = " UPDATE tblBikeEventList SET DelYN = 'Y' WHERE EventIdx = "& eventIdx &" "
  Call ajaxDb.ExecSQLReturnRs(deleteSQL, Null, B_ConStr)
End If

Session("titleIdx") = titleIdx
Server.Execute("/contest/event/info_list.asp")

ajaxDb.dispose()
Set ajaxDb = nothing
Set oJSONoutput = nothing
Set rst = nothing

%>
