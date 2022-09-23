<%
'#############################################

'리그테이블 생성

'#############################################
	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then
		midx = oJSONoutput.MIDX
	End If

	If hasown(oJSONoutput, "INVAL") = "ok" Then 
		inval = oJSONoutput.INVAL
	End if
	
	Set db = new clsDBHelper

	SQL = "update sd_gameMember set tryouttotalorder = '"&inval&"' where gameMemberIDX =  "&midx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>