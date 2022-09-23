<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->
<%
Set ajaxDb = new clsDBHelper
Dim req, mode, titleIdx , contents , thumbnail , contentsTitle , eventIdx
req = fInject(request("req"))

' 관리자id
adminId = "jaehongtest"

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
  mode          = oJSONoutput.get("mode")
  titleIdx      = oJSONoutput.get("titleIdx")
  videoIdx      = oJSONoutput.get("videoIdx")
  contents      = oJSONoutput.get("contents")
  thumbnail     = "https://img.youtube.com/vi/"& contents &"/mqdefault.jpg"
  contentsTitle = oJSONoutput.get("contentsTitle")
  eventIdx      = oJSONoutput.get("eventIdx")
End If


If mode = "insert" Then
  SQL =       " INSERT INTO tblBikeVideo ( TitleIdx , EventIdx , Contents , ContentsThumbnail , ContentsTitle, Writer ) "
  SQL = SQL & " VALUES ( "& titleIdx &" , "& eventIdx &", '"& contents &"', '"& thumbnail &"', '"& contentsTitle &"', '"& adminId &"' ) "
  Call ajaxDb.ExecSQLRS(SQL, Null, B_ConStr)
ElseIf mode = "update" Then
  SQL =       " UPDATE tblBikeVideo "
  SQL = SQL & " SET EventIdx = "& eventIdx &", Contents = '"& contents &"', ContentsTitle = '"& contentsTitle &"', UpdateDate = GETDATE(), Updater = '"& adminId &"' "
  SQL = SQL & " WHERE VideoIdx = "& videoIdx
  Call ajaxDb.ExecSQLRS(SQL, Null, B_ConStr)
ElseIf mode = "delete" Then
  SQL = " UPDATE tblBikeVideo SET DelYN = 'Y' WHERE VideoIdx = "& videoIdx &" "
  Call ajaxDb.ExecSQLRS(SQL, Null, B_ConStr)
End If

Session("titleIdx") = titleIdx
Server.Execute("/board/video/detail/info_list.asp")

ajaxDb.dispose()
Set ajaxDb = nothing
Set oJSONoutput = nothing

%>
