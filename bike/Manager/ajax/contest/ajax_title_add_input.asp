<!-- #include virtual = "/pub/header.bike.asp" -->

<%
Set ajaxDb = new clsDBHelper
Dim req, inputType, inputValue, insertSQL, returnIdx
req = fInject(request("req"))

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
End If

inputType = oJSONoutput.type
inputValue = oJSONoutput.value


Select Case inputType
Case "titleHead"
  insertSQL = "SET NOCOUNT ON INSERT INTO tblBikeTitleHead VALUES ('"& GLOBAL_HOSTCODE &"', '"& inputValue &"', 'N', GETDATE()) SELECT @@IDENTITY"
Case "gameArea"
  insertSQL = "SET NOCOUNT ON INSERT INTO tblBikeGameArea VALUES ('"& GLOBAL_HOSTCODE &"', '"& inputValue &"', 'N', GETDATE()) SELECT @@IDENTITY"
Case Else :
  insertSQL = ""
End Select

on error resume next
Set rsAjax = ajaxDb.ExecSQLReturnRs(insertSQL, Null, B_ConStr)
If Not rsAjax.eof Then
  returnIdx = rsAjax(0)
End If

If  err.Number > 0 Then
  oJSONoutput.Set("errorCode"), err.Number
Else
  oJSONoutput.Set("returnIdx"), returnIdx
End If

strJSON = JSON.Stringify(oJSONoutput)
response.write strJSON
response.end


ajaxDb.dispose()
Set ajaxDb = nothing
Set oJSONoutput = nothing
Set rsAjax = nothing


%>
