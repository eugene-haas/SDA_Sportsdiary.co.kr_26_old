<!-- #include virtual = "/pub/header.bike.asp" -->
<%
Set ajaxDb = new clsDBHelper
Dim req, titleIdx, openType, openState, changeState
req = fInject(request("req"))

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)

  titleIdx = oJSONoutput.titleIdx
  openType = oJSONoutput.openType
  If openType = "open" Then
    openType = ""
  End If
  openState = oJSONoutput.openState
  If openState = "N" Then
    changeState = "Y"
  Else
    changeState = "N"
  End If
End If

updateSQL = " UPDATE tblBikeTitle SET "& openType &"OpenYN = '"& changeState &"' WHERE TitleIdx = "& titleIdx &" AND DelYN = 'N' "
Call ajaxDb.ExecSQLRs(updateSQL, Null, B_ConStr)

oJSONoutput.Set("changeState"), changeState
strjson = JSON.Stringify(oJSONoutput)
response.write strjson
response.end

ajaxDb.dispose()
Set ajaxDb = nothing
Set oJSONoutput = nothing
%>
