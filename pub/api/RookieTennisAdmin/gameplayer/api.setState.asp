<%
'#############################################
'박탈 해제 ( 사유를 쓸수 있게 만들어야 .... 필드는 있음)
'#############################################

'request
pidx = oJSONoutput.PIDX
state = oJSONoutput.STATE

Set db = new clsDBHelper

If state = "0" Then
	SQL = "Update tblPlayer Set stateNo = '1' where playerIDX = " & pidx
Else
	SQL = "Update tblPlayer Set stateNo = '0' where playerIDX = " & pidx
End if

Call db.execSQLRs(SQL , null, ConStr)

'#############################################


Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>
