<!-- #include virtual = "/pub/header.bike.asp" -->
<%
Set ajaxDb = new clsDBHelper
Dim req, mode, busIdx, titleIdx, StartLocation, Destination, StartDate, StartTime
Dim BusMemberLimit, BusFare
req = fInject(request("req"))

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  mode = oJSONoutput.mode
  titleIdx = oJSONoutput.titleIdx
  StartLocation = oJSONoutput.StartLocation
  Destination = oJSONoutput.Destination
  StartDate = oJSONoutput.StartDate
  StartTime = oJSONoutput.StartTime
  BusMemberLimit = oJSONoutput.BusMemberLimit
  BusFare = oJSONoutput.BusFare
  if mode <> "insert" Then
    busIdx = oJSONoutput.busIdx
  end if
  if left(StartTime,2) = "오후" then
    StartTime = (Cint(mid(split(StartTime,":")(0),3))+12) & ":" & right(StartTime,2)
  Else
    StartTime = Cint(mid(split(StartTime,":")(0),3)) & ":" & right(StartTime,2)
  end if
End If


If mode = "insert" Then
  insertSQL =             " SET NOCOUNT ON INSERT INTO tblBikeBusList "
  insertSQL = insertSQL & " ( TitleIdx, StartLocation, StartDate, StartTime, Destination, BusMemberLimit, BusFare )"
  insertSQL = insertSQL & " VALUES  "
  insertSQL = insertSQL & " ( '"& titleIdx &"', '"& StartLocation &"', '"& replace(StartDate,"/","-") &"', '"& StartTime &"', '"& Destination &"', '"& BusMemberLimit & "', '"& BusFare &"' ) "
  insertSQL = insertSQL & " SELECT @@IDENTITY "
  Set rst = ajaxDb.ExecSQLReturnRs(insertSQL, Null, B_ConStr)
  If Not rst.eof Then
    rsTitleIdx = rst(0)
  End If
ElseIf mode = "update" Then
  updateSQL =             " UPDATE tblBikeBusList SET TitleIdx = "& titleIdx &", StartLocation = '"& StartLocation &"', StartDate = '"& StartDate &"', StartTime = '"& StartTime &"' "
  updateSQL = updateSQL & " , Destination = '"& Destination &"', BusMemberLimit = '"& BusMemberLimit &"', BusFare = '"& BusFare &"' "
  updateSQL = updateSQL & " WHERE BusIdx = '"& busIdx &"' "
  Call ajaxDb.ExecSQLRs(updateSQL, Null, B_ConStr)
ElseIf mode = "delete" Then
  deleteSQL = " UPDATE tblBikeBusList SET DelYN = 'Y' WHERE BusIdx = '"& busIdx &"' "
  Call ajaxDb.ExecSQLRs(deleteSQL, Null, B_ConStr)
End If

Server.Execute("/bus/info_list.asp")

ajaxDb.dispose()
Set ajaxDb = nothing
Set oJSONoutput = nothing
Set rst = nothing

%>
