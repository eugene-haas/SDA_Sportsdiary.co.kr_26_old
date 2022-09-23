<%
'#############################################

'#############################################

'request
pidx = oJSONoutput.PIDX
boono = oJSONoutput.BNO
chkvalue = oJSONoutput.CHK

Set db = new clsDBHelper


SQL = "select rankboo from tblPlayer where playerIDX = " & pidx
Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

bno = rs(0)
Dim rb(5)
rb(1) = Left(bno,1)
rb(2)= mid(bno,2,1)
rb(3) = mid(bno,3,1)
rb(4) = mid(bno,4,1)
rb(5) = mid(bno,5,1)
rb(boono) = chkvalue

For i = 1 To ubound(rb)
	newbno = newbno &  rb(i)
next

SQL = "Update tblPlayer Set rankboo = '"&newbno&"' where playerIDX = " & pidx
Call db.execSQLRs(SQL , null, ConStr)

'#############################################


Call oJSONoutput.Set("result", "0" )
strjson = JSON.stringify(oJSONoutput)
Response.Write strjson

db.Dispose
Set db = Nothing
%>
