<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->
<%
Set ajaxDb = new clsDBHelper
Dim req, mode, titleHeadIdx, titleName, titleType, sido, address, addressDetail
Dim addressZip, gameStartDate, gameEndDate, applyStartDate, applyEndDate, hostCode, hostIdx, rsTitleIdx
req = fInject(request("req"))

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  mode           = oJSONoutput.mode
  titleHeadIdx   = oJSONoutput.titleHeadIdx
  titleName      = oJSONoutput.titleName
  titleType      = oJSONoutput.titleType
  sido           = oJSONoutput.sido
  gameArea       = oJSONoutput.gameArea
  addressZip     = oJSONoutput.addressZip
  address        = oJSONoutput.address
  addressDetail  = oJSONoutput.addressDetail
  gameStartDate  = oJSONoutput.gameStartDate
  gameEndDate    = oJSONoutput.gameEndDate
  applyStartDate = oJSONoutput.applyStartDate
  applyEndDate   = oJSONoutput.applyEndDate
  hostCode       = oJSONoutput.hostCode
  If mode <> "insert" Then
    titleIdx = oJSONoutput.titleIdx
  End If
End If

SQL = " SELECT HostIdx FROM tblBikeHostCode WHERE HostCode = '"& hostCode &"' AND DelYN = 'N' "
Set rsh = ajaxDb.ExecSQLReturnRs(SQL, Null, B_ConStr)
If Not rsh.eof Then
  hostIdx = rsh(0)
Else
  oJSONoutput.Set("errorCode"), 1
  strjson = JSON.Stringify(oJSONoutput)
  response.write strjson
  response.end
End If

If mode = "insert" Then
  insertSQL =             " SET NOCOUNT ON INSERT INTO tblBikeTitle "
  insertSQL = insertSQL & " ( HostIdx, TitleHeadIdx, TitleName, Type, Sido, GameAreaIdx, AddressZip, Address, AddressDetail "
  insertSQL = insertSQL & " , StartDate, EndDate, ApplyStart, ApplyEnd )"
  insertSQL = insertSQL & " VALUES  "
  insertSQL = insertSQL & " ( '"& hostIdx &"', '"& titleHeadIdx &"', '"& titleName &"', '"& titleType &"', '"& sido &"', '"& gameArea & "' "
  insertSQL = insertSQL & " , '"& addressZip &"', '"& address &"', '"& addressDetail &"', '"& gameStartDate &"', '"& gameEndDate &"' "
  insertSQL = insertSQL & " , '"& applyStartDate &"', '"& applyEndDate &"' ) "
  insertSQL = insertSQL & " SELECT @@IDENTITY "
  Set rst = ajaxDb.ExecSQLReturnRs(insertSQL, Null, B_ConStr)
  If Not rst.eof Then
    rsTitleIdx = rst(0)
  End If
ElseIf mode = "update" Then
  updateSQL =             " UPDATE tblBikeTitle SET HostIdx = "& hostIdx &", TitleHeadIdx = '"& titleHeadIdx &"', TitleName = '"& titleName &"', Type = '"& titleType &"' "
  updateSQL = updateSQL & " , Sido = '"& sido &"', GameAreaIdx = '"& gameArea &"', AddressZip = '"& addressZip &"', Address = '"& address &"', AddressDetail = '"& addressDetail &"' "
  updateSQL = updateSQL & " , StartDate = '"& gameStartDate &"', EndDate = '"& gameEndDate &"', ApplyStart = '"& applyStartDate &"', ApplyEnd = '"& applyEndDate &"', UpdateDate = GETDATE() "
  updateSQL = updateSQL & " WHERE TitleIdx = '"& titleIdx &"' "
  Call ajaxDb.ExecSQLRs(updateSQL, Null, B_ConStr)
ElseIf mode = "delete" Then
  deleteSQL = " UPDATE tblBikeTitle SET DelYN = 'Y' WHERE TitleIdx = '"& titleIdx &"' "
  Call ajaxDb.ExecSQLRs(deleteSQL, Null, B_ConStr)
End If

Server.Execute("/contest/info_list.asp")

ajaxDb.dispose()
Set ajaxDb = nothing
Set oJSONoutput = nothing
Set rst = nothing

%>
