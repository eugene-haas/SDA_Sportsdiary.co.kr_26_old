<%
'#############################################
'체전에서 출전순서 변경
'#############################################

	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 
		idx= oJSONoutput.IDX
	End If
	If hasown(oJSONoutput, "IDX2") = "ok" Then 
		idx2= oJSONoutput.IDX2
	End If
	If hasown(oJSONoutput, "ST") = "ok" Then 
		st= oJSONoutput.ST
	End If

	If hasown(oJSONoutput, "ORDERNO") = "ok" Then 
		orderno= oJSONoutput.ORDERNO
	End If

	Set db = new clsDBHelper 

		If ST = "up" Then
			SQL = "update SD_tennisMember Set tryoutsortno = '"&orderno&"' where gameMemberIDX = " & idx2			
			Call db.execSQLRs(SQL , null, ConStr)			
			SQL = "update SD_tennisMember Set tryoutsortno = tryoutsortno - 1 where gameMemberIDX = " & idx
			Call db.execSQLRs(SQL , null, ConStr)	
		Else
			SQL = "update SD_tennisMember Set tryoutsortno = '"&orderno&"' where gameMemberIDX = " & idx2
			Call db.execSQLRs(SQL , null, ConStr)			
			SQL = "update SD_tennisMember Set tryoutsortno = tryoutsortno + 1 where gameMemberIDX = " & idx
			Call db.execSQLRs(SQL , null, ConStr)	
		End if

  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
