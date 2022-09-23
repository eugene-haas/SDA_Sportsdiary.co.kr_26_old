<%
'#############################################
'넌도 종목관리 생성
'DB SD_Riding 
'tblPubCode (코드 정의)
'년도별 등록된 코드값
'tblTeamGbInfo 
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX
	End If

	If hasown(oJSONoutput, "INVAL") = "ok" then
		inval= oJSONoutput.INVAL
	End If

	If hasown(oJSONoutput, "ARRKEY") = "ok" then
		arrkey= oJSONoutput.ARRKEY
	End If
	

	Set db = new clsDBHelper 


	  strFieldName = "  setpointarr "
	  SQL = "Select setpointarr from tblTeamGbInfo where DelYN = 'N' and TeamGbIDX = " & idx 
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If Not rs.EOF Then
		arrPub = rs.GetRows()
	  End If

	If IsArray(arrPub) Then

			setpointarr = arrPub(0, 0)
			ptvaluearr = Split(setpointarr, "`")
			ptvaluearr(arrkey) = inval

			strtoarr = ""
			For a = 0 To ubound(ptvaluearr)
				If a = 0 Then
					strtoarr = ptvaluearr(a)
				else
					strtoarr = strtoarr & "`" & ptvaluearr(a)
				End if
			next

		SQL = "update tblTeamGbInfo Set setpointarr  = '"&strtoarr&"' where DelYN = 'N' and TeamGbIDX = " & idx 
		Call db.execSQLRs(SQL , null, ConStr)
	End if



  Set rs = Nothing
  db.Dispose
  Set db = Nothing

  Call oJSONoutput.Set("result", "0" )
  strjson = JSON.stringify(oJSONoutput)
  Response.Write strjson

%>
