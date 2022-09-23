<%
'#############################################

'대회생성저장

'#############################################
	'request
	If hasown(oJSONoutput, "PARR") = "ok" then
		Set reqArr = oJSONoutput.PARR '23번까지 '13, 14 날짜형태
		'For intloop = 0 To oJSONoutput.PARR.length-1
		'   Response.write  reqArr.Get(intloop) & "<br>"
		'Next
		'Response.end
	End if

	Set db = new clsDBHelper 

		insertfield = " CDA,name,sex,teamnm,grade,team,userphone "

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "SET NOCOUNT ON INSERT INTO tblReferee ( "&insertfield&") VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		'Response.write sql
		'Response.end
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>