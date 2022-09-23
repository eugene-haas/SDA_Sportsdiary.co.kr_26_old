<!-- #include virtual = "/pub/header.bike.asp" -->
<%
Set ajaxDb = new clsDBHelper
Dim req, videoIdx
req = fInject(request("req"))

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  videoIdx   = oJSONoutput.videoIdx
  openState  = oJSONoutput.openState

  If openState = "N" Then
    changeState = "Y"
  Else
    changeState = "N"
  End If
End If

' 관리자id
adminId = "jaehongtest"

SQL = " UPDATE tblBikeVideo SET OpenYN = '"& changeState &"', Updater = '"& adminId &"', UpdateDate = GETDATE() WHERE VideoIdx = "& videoIdx &" "
Call ajaxDb.ExecSQLRs(SQL, Null, B_ConStr)


oJSONoutput.Set("changeState"), changeState
strjson = JSON.Stringify(oJSONoutput)
response.write strjson
response.end

ajaxDb.dispose()
Set ajaxDb = nothing
Set oJSONoutput = nothing
%>
