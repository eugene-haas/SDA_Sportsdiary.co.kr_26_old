<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<%
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'삭제
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		e_idx = oJSONoutput.IDX
	End if

	Set db = new clsDBHelper

	tablename = "tblTotalBoard"

	Sql = "update  "&tablename&" Set   DelYN = 'Y' where seq = " & e_idx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


