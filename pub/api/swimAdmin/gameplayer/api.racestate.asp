<%
'#############################################
'현장에서 입금체크할때 사용
'#############################################

'request
idx = oJSONoutput.IDX
chk = oJSONoutput.CHK

Set db = new clsDBHelper

SQL = "update tblGameRequest Set RACEOK = '"&chk&"' where RequestIDX = " & idx
Call db.execSQLRs(SQL , null, ConStr)



Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>


