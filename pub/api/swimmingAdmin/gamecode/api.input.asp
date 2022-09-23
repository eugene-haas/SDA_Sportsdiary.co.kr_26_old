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
		cda = reqArr.Get(0)
	End if

	Set db = new clsDBHelper 

		'If cda = "F2" Then
		'{""CMD"":301,""PARR"":[""F2"",""01"",""aa"",""test"",""1"",""2"",""-"",""3"",""4"",""5"",""솔로(Solo)""]}
		'insertfield = " CDA,CDC,CODE1,CODE2,CODE4,CODE5,codename,CODE6,CODE7,CODE8,title " 'title = cdcnm
		'else
		insertfield = " CDA,CDC,CODE1,CODE2,CODE3,CODE4,codename,title " 'title = cdcnm
		'End if

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "SET NOCOUNT ON INSERT INTO tblGameCode ( "&insertfield&") VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>