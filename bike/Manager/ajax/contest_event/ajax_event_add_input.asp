<!-- #include virtual = "/pub/header.bike.asp" -->

<%
Set ajaxDb = new clsDBHelper
Dim req, cType, code
req = fInject(request("req"))

If req <> "" Then
  Set oJSONoutput = JSON.Parse(req)
End If

code = oJSONoutput.code
cType = oJSONoutput.cType


checkSQL = " SELECT TypeName, ViewOrder FROM tblBikeEventCode WHERE Type = '"& cType &"' "
on error resume next
Set rsAjax = ajaxDb.ExecSQLReturnRs(checkSQL, Null, B_ConStr)

If  err.Number > 0 Then
  oJSONoutput.Set("errorCode"), err.Number
  strJSON = JSON.Stringify(oJSONoutput)
  response.write strJSON
  response.end
Else
  If Not rsAjax.eof Then
    cTypeName = rsAjax("TypeName")
    eventViewOrder = rsAjax("ViewOrder")
  End If
End If

insertSQL = " SET NOCOUNT ON INSERT INTO tblBikeEventCode VALUES ( '"& cType &"', '"& cTypeName &"', '"& code &"', '"& eventViewOrder &"') SELECT @@IDENTITY "
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
