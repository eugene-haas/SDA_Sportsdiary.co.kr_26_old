<%
'#############################################
'순서에서 오전순서 제거
'#############################################
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End If
	If hasown(oJSONoutput, "GAMEDATE") = "ok" then
		gamedate = oJSONoutput.GAMEDATE
	End If
	
	If hasown(oJSONoutput, "SVTYPE") = "ok" then
		svtype = oJSONoutput.SVTYPE
	End if

	Select Case svtype
	Case "D" '다이빙
		CDA = "E2"
		soogoo = " and  CDC<>'31' " 
	Case "A" '아티스틱
		CDA = "F2"
		soogoo = "" 
	Case "S" '수구
		CDA = "E2"
		soogoo = " and  CDC='31' " 
	End Select 


	Set db = new clsDBHelper

	SQL = "Update tblRGameLevel Set tryoutgamedate = '" & Replace(gamedate,"/","-") &"',tryoutgamestarttime = '09:00',gubunam='3' where delyn = 'N' and gametitleidx  = " & tidx & " and cda = '"&cda&"'  " & soogoo

'Response.write sql
'Response.end
	Call db.execSQLRs(SQL , null, ConStr) 	



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


