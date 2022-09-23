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

		tblnm = "tblPlayer"
		chkfld = "username"

		'동일 팀명칭 체크 막는다면 userphone까지 합쳐서 막음
		'SQL = "Select "&chkfld&" from "&tblnm&" where "&chkfld&" = '" & reqArr.Get(1) & "' "
		'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		'If not rs.eof Then
		'	Call oJSONoutput.Set("result", 2 )
		'	strjson = JSON.stringify(oJSONoutput)
		'	Response.Write strjson
		'	Response.end
		'End if

		insertfield = " userType,UserName,UserPhone,Ajudgelevel,Kef1,Kef2,Kef3,Kef4,FEI1,FEI2,FEI3,FEI4,FEI5,FEI6,FEI7,FEI8,FEI9 "

		For i = 0 To oJSONoutput.PARR.length-1
			Select Case i
			Case 0
				insertvalue	= " '"&reqArr.Get(i)&"' "
			Case Else
					insertvalue	= insertvalue & ",'"&reqArr.Get(i)&"' "
			End Select 
		next

		SQL = "SET NOCOUNT ON INSERT INTO "&tblnm&" ( "&insertfield&" ) VALUES " 'confirm 확인여부
		SQL = SQL & "( "&insertvalue&" ) SELECT @@IDENTITY"
		'Response.write sql
		'Response.End
		
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		idx = rs(0)

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>